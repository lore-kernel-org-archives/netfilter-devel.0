From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC] netfilter: xt_TEE:  IPv4 Don't Fragmet options
Date: Fri, 15 Jun 2012 01:55:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206141245180.27937@frira.zrqbmnf.qr>
References: <rvd97lb.cb16bfe930b2100854041c0a3d714500@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	fw@strlen.de
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39750 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2FNX4C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:56:02 -0400
In-Reply-To: <rvd97lb.cb16bfe930b2100854041c0a3d714500@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-06-14 08:17, Hans Schillstrom wrote:

>Hello,
>
>I  think it is wrong to always force the DF bit in IPv4, it's better to have an option

Do you experience an actual problem?

>If an application don't set the DF bit, usually it doesn't expect to 
>get an icmp back either.

Applications often don't have the means to set DF, think SOCK_STREAM.

>The result is that the packet will be dropped...

And exactly because of that, an ICMP message should be generated, to 
notify the sender about a reduced MTU, so that the TEE destination does 
in fact get the messages.

>
>To retain backwards compatibility I suggest adding a new option like
>
>--ipv4-df-copy  Do not force "Don't Fragment" on the copied packet just copy the bit.
>
>In IPv6 we don't have that option, so nothing has to be done there.
>
>
>diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_TEE.h
>index 5c21d5c..e5fca8a 100644
>--- a/include/linux/netfilter/xt_TEE.h
>+++ b/include/linux/netfilter/xt_TEE.h
>@@ -4,6 +4,7 @@
> struct xt_tee_tginfo {
>        union nf_inet_addr gw;
>        char oif[16];
>+       int df_copy;
>
>        /* used internally by the kernel */
>        struct xt_tee_priv *priv __attribute__((aligned(8)));

As Pablo mentioned, you cannot touch this structure.

"int" is also a bad idea. - See my very own "Writing Netfilter Modules" 
pdf for details.
