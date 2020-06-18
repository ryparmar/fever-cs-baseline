from fever.api.web_server import fever_web_api


def make_api(*args):
    # Set up and initialize model

    # A prediction function that is called by the API
    def baseline_predict(instances):
        predictions = []
        for instance in instances:
            pass
        return predictions

    return fever_web_api(baseline_predict)
