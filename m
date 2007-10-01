From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/13] iptables TPROXY target
Date: Mon, 01 Oct 2007 16:11:19 +0200
Message-ID: <47010007.4080606@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205335.10969.91031.stgit@nessa.odu> <470026AF.5060404@trash.net> <200710010051.04814@nessa> <Pine.LNX.4.64.0710010053190.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: KOVACS Krisztian <hidden@sch.bme.hu>,
	netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33654 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbXJAOLp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:11:45 -0400
In-Reply-To: <Pine.LNX.4.64.0710010053190.7130@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 1 2007 00:51, KOVACS Krisztian wrote:
> 
>>>>+/* TPROXY target is capable of marking the packet to perform
>>>>+ * redirection. We can get rid of that whenever we get support for
>>>>+ * mutliple targets in the same rule. */
>>>>+struct ipt_tproxy_target_info {
>>>>+	__be32 laddr;
>>>>+	__be16 lport;
>>>>+	unsigned long mark_mask;
>>>>+	unsigned long mark_value;
>>>
>>>This should use fixed size types.
>>
>>Yes, but marks are unsigned longs, aren't they? So if we restrict this to say
>>32bit then we lose the ability to use the upper half of the mark...
> 
> 
> longs are 32 and 64 bits, resp. A 64-bit kernel with a 32-bit userland,
> well it speaks for itself.
> 
> The more I am puzzled as to why xt_MARK.h, xt_mark.h, xt_CONNMARK.h,
> xt_connmark.h use longs, and not uint32_t! Only xt_SECMARK.h does it right...
> 
> Patrick, is this a longstanding 'bug'?


Not a bug, compatiblity crap. skb->nfmark used to be unsigned long,
but since a) it sucks to have userspace-visible stuff like this
depend on the architecture and b) routing, classifiers etc. all
only supported 32 bits, we've changed it.

