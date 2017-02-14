From: Vishwanath Pai <vpai@akamai.com>
Subject: Parameter 'size' in type list:set is ignored
Date: Tue, 14 Feb 2017 17:24:54 -0500
Message-ID: <921798b7-0b87-2e15-9f6f-b33adb46c3b8@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Joshua Hunt <johunt@akamai.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:42542 "EHLO
        prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750749AbdBNWaC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Feb 2017 17:30:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

I noticed that in recent versions of ipset the parameter 'size' in set
type list:set is ignored. I noticed this change in the latest upstream
code. In kernel 4.1 'ipset add' errors out when I try to add more
elements than 'size' but in 4.10 it does not. For example, if the size
is set to 4 and I try to add a fifth element to the set: in 4.1 it
errors out with "set is full" but if I try the same in 4.10 kernel it
lets me add the 5th element.

I think this change was introduced in v4.2 by the following commit:
commit 00590fdd5be0d763631ef10e6a3e2ce8fc2d9ec3
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Jun 13 16:56:02 2015 +0200

    netfilter: ipset: Introduce RCU locking in list type

    Standard rculist is used.

    Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

I've demonstrated this below on both the kernels (the example is very
similar to the test setlist.t):

$> ipset -v
ipset v6.21.1, protocol version: 6

$> uname -r
4.1.36

$> ipset l test
Name: test
Type: list:set
Revision: 2
Header: size 4 timeout 500
Size in memory: 144
References: 0
Number of entries: 0
Members:

$> ipset add test a
$> ipset add test b
$> ipset add test c
$> ipset add test d

$> ipset l test
Name: test
Type: list:set
Revision: 2
Header: size 4 timeout 500
Size in memory: 144
References: 0
Number of entries: 4
Members:
a timeout 488
b timeout 489
c timeout 490
d timeout 491

$> ipset add test e
ipset v6.21.1: The set is full, more elements cannot be added.

Doing the same in kernel 4.10 would let me add the 5th element to the set:

$> ipset -v
ipset v6.30, protocol version: 6

$> uname -r
4.10.0-rc8

$> ipset l test
Name: test
Type: list:set
Revision: 3
Header: size 4 timeout 500
Size in memory: 80
References: 0
Number of entries: 0
Members:

$> ipset add test a
$> ipset add test b
$> ipset add test c
$> ipset add test d
$> ipset add test e

$> ipset l test
Name: test
Type: list:set
Revision: 3
Header: size 4 timeout 500
Size in memory: 360
References: 0
Number of entries: 5
Members:
a timeout 486
b timeout 488
c timeout 490
d timeout 491
e timeout 496

Adding more elements than 'size' does not break anything but has a
side-effect. For example in 4.1 kernel the command 'ipset add test e
before d' would replace d with e but on 4.10 kernel it will simply add e
to the list before d without replacing it.

Was this change intentional? Or should we be enforcing 'max elements' on
this set type? If we should enforce the limit then I can send a patch to
fix it. Please let me know.

Thanks,
Vishwanath

