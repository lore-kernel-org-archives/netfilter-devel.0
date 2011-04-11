From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset-6.3 unexpected htable order
Date: Mon, 11 Apr 2011 05:28:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104110439420.14676@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55417 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1DKD26 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Apr 2011 23:28:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hej,


What would it mean if this testcase failure occured to me? I have
observing this issue reproducibly with ipset-6.3-genl, though I can't
make heads-tails of it. Apparently the members are the same, albeit
in different order (which should be irrelevant in hashes anyway), and
less memory happens to be used in this occurrence.

What immediately comes to mind about the different order is that
the hash was perturbed, perhaps by an uninitialized variable or
otherwise undefined operation.

I know I can't expect you to dig around in the GENL patch, but maybe
you are interested. The latest is at git://dev.medozas.de/ipset-6 genl .

The fact that occurs only on ipv6 hash types is also worth mentioning.

hash:ip6,port: Check listing:
--- .foo  2011-04-11 04:27:28.384089921 +0200
+++ hash:ip6,port.t.list0       2011-04-04 00:22:28.398552604 +0200
@@ -1,11 +1,11 @@
 Name: test
 Type: hash:ip,port
 Header: family inet6 hashsize 1024 maxelem 65536 timeout x
-Size in memory: 17112
+Size in memory: 8848
 References: 0
 Members:
-2:1::,tcp:128 timeout x
 2:1::1,tcp:128 timeout x
-2::,tcp:5 timeout x
+2:1::,tcp:128 timeout x
 2::1,tcp:5 timeout x
+2::,tcp:5 timeout x

FAILED
Failed test: diff -uI 'Size in memory.*' .foo hash:ip6,port.t.list0

Other tests affected:
 hash:ip6,port,ip6
 hash:net6
 hash:net6,port
 hash:ip6,port,net6

