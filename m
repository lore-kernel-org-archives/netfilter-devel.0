From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] tests: add regression tests for
 xtables-translate
Date: Fri, 7 Apr 2017 17:52:31 +0200
Message-ID: <20170407155231.GA3324@salvia>
References: <20170331123438.29573-1-pablombg@gmail.com>
 <20170406225815.GA3041@salvia>
 <CAAaDf4vZm3dZLuvgHeFV-fqJCCf25vFCuYq_QqR6LWhXX6a+8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933040AbdDGPwx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 11:52:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B3B9E1373A5
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:52:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A050CDA86B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:52:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70009DA862
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:52:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAAaDf4vZm3dZLuvgHeFV-fqJCCf25vFCuYq_QqR6LWhXX6a+8g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 07, 2017 at 12:46:23PM +0200, Pablo M. Bermudo Garay wrote:
> > Nice... But how this works? :)
> >
> > # python xlate-test.py
> > Traceback (most recent call last):
> >   File "xlate-test.py", line 85, in <module>
> >     main()
> >   File "xlate-test.py", line 78, in main
> >     load_test_files()
> >   File "xlate-test.py", line 65, in load_test_files
> >     run_test(test, payload)
> >   File "xlate-test.py", line 43, in run_test
> >     output = subprocess.run(shlex.split(line), stdout=subprocess.PIPE)
> > AttributeError: 'module' object has no attribute 'run'
> 
> The script is written using python3. The shebang points to the python3
> interpreter, so the script can be executed with ./xlate-test.py or
> python3 xlate-test.py.

This seems to need Python 3.5 specifically, this was breaking here
with Python 3.4 ;)

Anyway I have applied this, but I see tests reporting failures...

Please follow up and fix that seem to be related to your setup:

        iptables-translate v1.6.1: label 'bit40' not found

There seem to be also some problems in the current output that cause
mismatches. This may need small fixes to some of the extensions.

I would appreciate if you can follow up and fix those, thanks!
