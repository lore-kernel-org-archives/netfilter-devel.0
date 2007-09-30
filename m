From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 11/13] iptables TPROXY target
Date: Mon, 1 Oct 2007 00:57:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710010053190.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <20070930205335.10969.91031.stgit@nessa.odu> <470026AF.5060404@trash.net>
 <200710010051.04814@nessa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60103 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbXI3W5e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:57:34 -0400
In-Reply-To: <200710010051.04814@nessa>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 1 2007 00:51, KOVACS Krisztian wrote:
>> > +/* TPROXY target is capable of marking the packet to perform
>> > + * redirection. We can get rid of that whenever we get support for
>> > + * mutliple targets in the same rule. */
>> > +struct ipt_tproxy_target_info {
>> > +	__be32 laddr;
>> > +	__be16 lport;
>> > +	unsigned long mark_mask;
>> > +	unsigned long mark_value;
>>
>> This should use fixed size types.
>
>Yes, but marks are unsigned longs, aren't they? So if we restrict this to say
>32bit then we lose the ability to use the upper half of the mark...

longs are 32 and 64 bits, resp. A 64-bit kernel with a 32-bit userland,
well it speaks for itself.

The more I am puzzled as to why xt_MARK.h, xt_mark.h, xt_CONNMARK.h,
xt_connmark.h use longs, and not uint32_t! Only xt_SECMARK.h does it right...

Patrick, is this a longstanding 'bug'?
