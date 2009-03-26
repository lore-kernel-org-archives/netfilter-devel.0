From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptable_nat and ip_conntrack coupling
Date: Thu, 26 Mar 2009 18:26:27 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903261823200.7735@fbirervta.pbzchgretzou.qr>
References: <0199E0D51A61344794750DC57738F58E6677CE122D@GVW1118EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Fischer, Anna" <anna.fischer@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41116 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbZCZR03 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:26:29 -0400
In-Reply-To: <0199E0D51A61344794750DC57738F58E6677CE122D@GVW1118EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-26 18:04, Fischer, Anna wrote:

>I'd like to understand how tightly integrated the iptable_nat code
>is with ip_conntrack. If I have rules that define what packets are
>supposed to be NATed (e.g. -j SNAT --to x.x.x.x or -j DNAT --to
>x.x.x.x), then does the code *always* do NAT on packets that match
>those rules?

Only packets with their nf_conn in the NEW state will visit the nat
table, after which a nat-table independent mapping in nf_nat does
the rest. Use of the NOTRACK extension disables thes on a per-packet
basis.

>Or, is there also the requirement that there has to be
>a connection maintained by ip_conntrack before packets are to be
>rewritten?

There is. And in fact, such a connection exists by the time the
rewrite metadata is applied for the first time.

>For example, if there is an ICMP packet coming through
>the iptable_nat code, and it is a REPLY where ip_conntrack has not
>tracked a REQUEST for, then will this prevent the code from
>rewriting the packet, even if the rules match the packet?

Not prevented (see paragraph above).
