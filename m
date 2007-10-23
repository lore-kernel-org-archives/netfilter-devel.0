From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Add xt_tos
Date: Tue, 23 Oct 2007 17:25:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710231724030.16684@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr>
 <471A2338.6060501@trash.net> <Pine.LNX.4.64.0710201809380.1997@fbirervta.pbzchgretzou.qr>
 <471E0162.7060702@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39037 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbXJWPZC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:25:02 -0400
In-Reply-To: <471E0162.7060702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 23 2007 16:12, Patrick McHardy wrote:
>> > > +struct xt_tos_info {
>> > > +	u_int8_t tos;
>> > > +	u_int8_t invert;
>> > > +};
>
> XT_ALIGN - it pads to multiples of the highest alignment
> requirement of u{8,16,32,64} - which is 1 one CRIS.

Even then I do not see where the problem is.
If CRIS kernelspace has 1-alignment, then its userspace
will have the same.

>> Note that ipt_tos(_match)_info also had these two fields.
>
> Right, I mixed something up. So the patch I queued (attached
> again for reference) seems to be fine.
>
Please drop it, I resend it (with new functionality).
