From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables 1.4.0 and Linux 2.4
Date: Mon, 31 Dec 2007 03:48:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712310346070.2093@fbirervta.pbzchgretzou.qr>
References: <x6fxxklbaj@gzp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Gabor Z. Papp" <gzp@papp.hu>, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50452 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXLaCsK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2007 21:48:10 -0500
In-Reply-To: <x6fxxklbaj@gzp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 30 2007 11:36, Gabor Z. Papp wrote:
>In file included from include/linux/netfilter/nf_nat.h:4,
>                 from extensions/libipt_DNAT.c:9:
>include/linux/netfilter/nf_conntrack_tuple.h:29: error: syntax error before "__be32"

It is because nf_inet_addr is not known to iptables with your kernel.


Question to Patrick: where is netfilter.h in the iptables
source directory
gone?

