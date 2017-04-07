From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [PATCH iptables] tests: add regression tests for xtables-translate
Date: Fri, 7 Apr 2017 12:48:06 +0200
Message-ID: <CAAaDf4s5CTVJBf-_efXdy3fX5bxV_7pJaqdWDO=gk-OU3iPpTg@mail.gmail.com>
References: <20170331123438.29573-1-pablombg@gmail.com> <20170406225815.GA3041@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37809 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754815AbdDGKsJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 06:48:09 -0400
Received: by mail-it0-f54.google.com with SMTP id a140so40700050ita.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Apr 2017 03:48:08 -0700 (PDT)
In-Reply-To: <20170406225815.GA3041@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Nice... But how this works? :)
>
> # python xlate-test.py
> Traceback (most recent call last):
>   File "xlate-test.py", line 85, in <module>
>     main()
>   File "xlate-test.py", line 78, in main
>     load_test_files()
>   File "xlate-test.py", line 65, in load_test_files
>     run_test(test, payload)
>   File "xlate-test.py", line 43, in run_test
>     output = subprocess.run(shlex.split(line), stdout=subprocess.PIPE)
> AttributeError: 'module' object has no attribute 'run'

The script is written using python3. The shebang points to the python3
interpreter, so the script can be executed with ./xlate-test.py or
python3 xlate-test.py.
