From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nft] about commit 3e5b0e406cf2b635200f9ee05ba8a158528fe622
Date: Thu, 17 Nov 2016 15:47:20 +0100
Message-ID: <CAOkSjBgU9j+78-T+648ytWd3RhC7Ce+dAT1PBTNKKS0o5V_pnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Manuel Johannes Messner
        <manuel.johannes.messner@hs-furtwangen.de>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35257 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934176AbcKQRIS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Nov 2016 12:08:18 -0500
Received: by mail-wm0-f51.google.com with SMTP id a197so323283604wmd.0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2016 09:08:18 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com. [74.125.82.53])
        by smtp.gmail.com with ESMTPSA id l67sm16075751wmf.0.2016.11.17.06.47.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Nov 2016 06:47:41 -0800 (PST)
Received: by mail-wm0-f53.google.com with SMTP id a197so315019337wmd.0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2016 06:47:41 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

commit id 3e5b0e406cf2b635200f9ee05ba8a158528fe622 :

tests: py: nft-tests.py: Add function for loading and removing kernel modules

introduces dummy kernel module loading to tests/py/nft-test.py.

The justification is that some tests are using the dummy module, but I
don't see them:

% git grep dummy tests/py/
tests/py/any/meta.t:meta iifname "dummy0";ok;iifname "dummy0"
tests/py/any/meta.t:meta iifname != "dummy0";ok;iifname != "dummy0"
tests/py/any/meta.t:meta iifname {"dummy0", "lo"};ok
tests/py/any/meta.t:- meta iifname != {"dummy0", "lo"};ok
tests/py/any/meta.t:meta iifname "dummy*";ok;iifname "dummy*"
tests/py/any/meta.t:meta iifname "dummy\*";ok;iifname "dummy\*"
tests/py/any/meta.t:meta oifname "dummy0";ok;oifname "dummy0"
tests/py/any/meta.t:meta oifname != "dummy0";ok;oifname != "dummy0"
tests/py/any/meta.t:meta oifname { "dummy0", "lo"};ok
tests/py/any/meta.t:meta oifname "dummy*";ok;oifname "dummy*"
tests/py/any/meta.t:meta oifname "dummy\*";ok;oifname "dummy\*"
tests/py/any/meta.t:meta oifname "dummy2" accept;ok;oifname "dummy2" accept
tests/py/any/meta.t.payload:# meta iifname "dummy0"
tests/py/any/meta.t.payload:# meta iifname != "dummy0"
tests/py/any/meta.t.payload:# meta iifname {"dummy0", "lo"}
tests/py/any/meta.t.payload:# meta iifname "dummy*"
tests/py/any/meta.t.payload:# meta iifname "dummy\*"
tests/py/any/meta.t.payload:# meta oifname "dummy0"
tests/py/any/meta.t.payload:# meta oifname != "dummy0"
tests/py/any/meta.t.payload:# meta oifname { "dummy0", "lo"}
tests/py/any/meta.t.payload:# meta oifname "dummy*"
tests/py/any/meta.t.payload:# meta oifname "dummy\*"
tests/py/any/meta.t.payload:# meta oifname "dummy2" accept
tests/py/nft-test.py:    modprobe('dummy')

all the "dummy" usages are from iifname/oifname, which uses the
interface name as a string and doesn't care about the interface
actually existing.

The nft-test.py script will segfault in systems where the dummy kernel
module isn't present, so the testsuite itself will fail:

Traceback (most recent call last):
  File "./nft-test.py", line 1057, in <module>
    main()
  File "./nft-test.py", line 995, in main
    modprobe('dummy')
  File "./nft-test.py", line 135, in modprobe
    ret = subprocess.call(cmds['del' if remove else 'ins']) == 0
  File "/usr/lib/python2.7/subprocess.py", line 168, in call
    return Popen(*popenargs, **kwargs).wait()
  File "/usr/lib/python2.7/subprocess.py", line 390, in __init__
    errread, errwrite)
  File "/usr/lib/python2.7/subprocess.py", line 1024, in _execute_child
    raise child_exception
OSError: [Errno 2] No such file or directory

I can't find a reason to keep this code, Should we revert the commit?

regards.
