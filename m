From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: iptables automated tests
Date: Tue, 8 Oct 2013 11:41:20 +0200
Message-ID: <20131008094120.GA7068@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37946 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3JHJlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:41:25 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following branch contains a new automated test infrastructure for
iptables:

http://git.netfilter.org/iptables/log/?h=tests-iptables

It's basically a python script that takes an input file '.t' that look
like:

:INPUT,OUTPUT,FORWARD
-p udp -m udp --sport 1;=;OK
-p udp -m udp --sport 65535;=;OK
-p udp -m udp --dport 1;=;OK
-p udp -m udp --dport 65535;=;OK
-p udp -m udp --sport 1:1023;=;OK
-p udp -m udp --sport 1024:65535;=;OK
[...]
-p udp -m udp --sport -1;;FAIL

Some explanation of the file format:

Lines starting by ':' mean the chains where you want to test the
rules, then lines with '#' are comments.

We also have '*' to indicate the table and '@' to execute some
external command.

Remaining lines look like:

-p udp -m udp --dport 1;=;OK
\_____________________/ _ __
          1             2  3

Part 1 is the rule that you want to load, then part 2 using '=' means
that the output via iptables-save look exactly the same like the
original command (in some case, the input command does not match the
output command that is fetch from the kernel, thus, this line to
include exceptions). Part 3 indicates if the test should run
successfully or fail.

The infrastructure allows us to test that iptables configurations are
consistent between userspace and the kernel. During the workshop we
discussed ideas for another infrastructure to test the packet
processing path, which are complementary to this infrastructure.

Regards.
