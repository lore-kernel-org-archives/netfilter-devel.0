From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf_conntrack.acct has no effect
Date: Mon, 16 Mar 2009 17:53:13 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48281 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZCPQxP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:53:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


A forum made me (re)aware of

Mar 15 18:20:25 wild-thing kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Mar 15 18:20:25 wild-thing kernel: CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
Mar 15 18:20:25 wild-thing kernel: nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
Mar 15 18:20:25 wild-thing kernel: sysctl net.netfilter.nf_conntrack_acct=1 to enable it.

which prompted me to look into this a bit in detail. I was wondering
which functionality I would lose on not setting nf_conntrack.acct. To
my surprise, there is no loss of functionality, as the "nf_ct_acct"
in nf_conntrack_acct.c nor /proc/sys/net/netfilter/nf_conntrack_acct
which is the accompanied sysctl file cause the packet or byte
counters to disappear from `conntrack -L` or /proc/net/nf_conntrack.

Should the message be removed? Should the missing check for
nf_ct_acct be included?
