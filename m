From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 17:45:29 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com> <48A5CEFE.5090407@netfilter.org> <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Changli Gao <xiaosuo@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42075 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYHOVpb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:45:31 -0400
In-Reply-To: <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-08-15 16:48, Jozsef Kadlecsik wrote:
>
>Reading the manpage, realm does not clash with either mark or connmark.

Right you are. My grep-fu turned up wrong comments! (See libxt_realm.c
for --mark!)

>> - ecn and ECN
>
>The options of the ecn match and the ECN target are not clashing.

They do. Both libipt_ecn.c and libipt_ECN.c have --ecn-ip-ect,
--ecn-tcp-cwr and --ecn-tcp-ece even if they are not documented
(what, more of these? Patch follows).

