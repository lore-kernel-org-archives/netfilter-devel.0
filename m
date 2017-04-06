From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] tests: add regression tests for
 xtables-translate
Date: Fri, 7 Apr 2017 00:58:15 +0200
Message-ID: <20170406225815.GA3041@salvia>
References: <20170331123438.29573-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751039AbdDFW6X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:58:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DFDCB137B8A
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:58:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CEEB8DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:58:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18030DA804
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:58:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170331123438.29573-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 31, 2017 at 02:34:38PM +0200, Pablo M. Bermudo Garay wrote:
> This test suite is intended to detect regressions in the translation
> infrastructure. The script checks if ip[6]tables-translate produces the
> expected output, otherwise it prints the wrong translation and the
> expected one.
> 
> ** Arguments
> 
>   --all     # Show also passed tests
>   [test]    # Run only the specified test file
> 
> ** Test files structure
> 
> Test files are located under extensions directory. Every file contains
> tests about specific extension translations. A test file name must end
> with ".txlate".
> 
> Inside the files, every single test is defined by two consecutive lines:
> ip[6]tables-translate command and expected result. One blank line is left
> between tests by convention.
> 
> e.g.
> 
>   $ cat extensions/libxt_cpu.txlate
>   iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
>   nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept
> 
>   iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
>   nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept

Nice... But how this works? :)

# python xlate-test.py 
Traceback (most recent call last):
  File "xlate-test.py", line 85, in <module>
    main()
  File "xlate-test.py", line 78, in main
    load_test_files()
  File "xlate-test.py", line 65, in load_test_files
    run_test(test, payload)
  File "xlate-test.py", line 43, in run_test
    output = subprocess.run(shlex.split(line), stdout=subprocess.PIPE)
AttributeError: 'module' object has no attribute 'run'
