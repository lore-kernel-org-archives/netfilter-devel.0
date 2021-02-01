Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA03C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 03:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B4964E27
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 03:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBADcd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 31 Jan 2021 22:32:33 -0500
Received: from correo.us.es ([193.147.175.20]:40576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhBADcc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 31 Jan 2021 22:32:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C8A83DA7EC
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 04:31:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6A17DA78D
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 04:31:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC394DA78C; Mon,  1 Feb 2021 04:31:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56A4ADA72F;
        Mon,  1 Feb 2021 04:31:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Feb 2021 04:31:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3C97E426CC84;
        Mon,  1 Feb 2021 04:31:48 +0100 (CET)
Date:   Mon, 1 Feb 2021 04:31:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH 1/3] tests: introduce new python-based
 framework for running tests
Message-ID: <20210201033147.GA20941@salvia>
References: <161144773322.52227.18304556638755743629.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <161144773322.52227.18304556638755743629.stgit@endurance>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Sun, Jan 24, 2021 at 01:22:37AM +0100, Arturo Borrero Gonzalez wrote:
> This test suite should help us develop better tests for conntrack-tools in general and conntrackd
> in particular.
> 
> The framework is composed of a runner script, written in python3, and 3 yaml files for
> configuration and testcase definition:
> 
>  - scenarios.yaml: contains information on network scenarios for tests to use
>  - tests.yaml: contains testcase definition
>  - env.yaml: contains default values for environment variables
> 
> The test cases can be anything, from a simple command to an external script call to perform more
> complex operations. See follow-up patches to know more on how this works.
> 
> The plan is to replace or call from this framework the other testsuites in this tree.
> 
> The runner script is rather simple, and it should be more or less straight forward to use it.
> It requires the python3-yaml package to be installed.
> 
> For reference, here are the script options:
> 
> === 8< ===
> $ tests/cttools-testing-framework.py --help
> usage: cttools-testing-framework.py [-h] [--tests-file TESTS_FILE]
> 				[--scenarios-file SCENARIOS_FILE]
> 				[--env-file ENV_FILE]
> 				[--single SINGLE]
> 				[--start-scenario START_SCENARIO]
> 				[--stop-scenario STOP_SCENARIO]
> 				[--debug]
> 
> Utility to run tests for conntrack-tools
> 
> optional arguments:
>   -h, --help            show this help message and exit
>   --tests-file TESTS_FILE
>                         File with testcase definitions. Defaults to 'tests.yaml'
>   --scenarios-file SCENARIOS_FILE
>                         File with configuration scenarios for tests. Defaults to 'scenarios.yaml'
>   --env-file ENV_FILE   File with environment variables for scenarios/tests. Defaults to 'env.yaml'
>   --single SINGLE       Execute a single testcase and exit. Use this for developing testcases
>   --start-scenario START_SCENARIO
>                         Execute scenario start commands and exit. Use this for developing testcases
>   --stop-scenario STOP_SCENARIO
>                         Execute scenario stop commands and exit. Use this for cleanup
>   --debug               debug mode
> === 8< ===
> 
> To run it, simply use:
> 
> === 8< ===
> $ cd tests/ ; sudo ./cttools-testing-framework.py

Automated regression test infrastructure is nice to have!

A few nitpick requests and one suggestion:

* Rename cttools-testing-framework.py to conntrackd-tests.py
* Move it to the tests/conntrackd/ folder
* Missing yaml dependency in python in my test machine

Traceback (most recent call last):
  File "cttools-testing-framework.py", line 36, in <module>
    import yaml
ModuleNotFoundError: No module named 'yaml'

this is installed from pip, right? Just a note in the commit message
is fine.

* Would it be possible to define the scenario in shell script files?
  For example, to define the "simple_stats" scenario, the YAML file
  looks like this:

- name: simple_stats
- script: shell/simple_stats.sh

The shell script takes "start" or "stop" as $1 to set up the scenario.
For developing more test, having the separated shell script might be
convenient.

This also allows to run scenario for development purpose away from the
automated regression infrastructure (although, you already thought
about this with the --start-scenario and --stop-scenario options, I
think those options are fine, I would not remove them).

Thanks !
