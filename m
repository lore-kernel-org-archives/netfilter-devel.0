From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH 11/13] iptables TPROXY target
Date: Mon, 1 Oct 2007 01:06:40 +0200
Message-ID: <200710010106.40769@nessa>
References: <20070930205141.10969.27205.stgit@nessa.odu> <200710010051.04814@nessa> <470029A1.9000506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:41541 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbXI3XGi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:06:38 -0400
In-Reply-To: <470029A1.9000506@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Monday 01 October 2007, Patrick McHardy wrote:
> KOVACS Krisztian wrote:
> > Hi Patrick,
> >
> > On Monday 01 October 2007, Patrick McHardy wrote:
> >> KOVACS Krisztian wrote:
> >>> The TPROXY target implements redirection of non-local TCP/UDP
> >>> traffic to local sockets. Additionally, it's possible to manipulate
> >>> the packet mark if and only if a socket has been found. (We need
> >>> this because we cannot use multiple targets in the same iptables
> >>> rule.)
> >>>
> >>> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
> >>> ---
> >>> +++ b/include/linux/netfilter_ipv4/ipt_TPROXY.h
> >>> @@ -0,0 +1,14 @@
> >>> +#ifndef _IPT_TPROXY_H_target
> >>> +#define _IPT_TPROXY_H_target
> >>> +
> >>> +/* TPROXY target is capable of marking the packet to perform
> >>> + * redirection. We can get rid of that whenever we get support for
> >>> + * mutliple targets in the same rule. */
> >>> +struct ipt_tproxy_target_info {
> >>> +	__be32 laddr;
> >>> +	__be16 lport;
> >>> +	unsigned long mark_mask;
> >>> +	unsigned long mark_value;
> >>
> >> This should use fixed size types.
> >
> > Yes, but marks are unsigned longs, aren't they? So if we restrict
> > this to say 32bit then we lose the ability to use the upper half of
> > the mark...
>
> No, marks are 32 bit for a long time now. The unsigned longs in
> the mark target and matches are just there for compatiblity.

Indeed, I must have missed this. Obviously if this is the case then we 
don't need all this cruft and can simply use 32 bit mark fields (and the 
reordered info structure Jan suggested.)

> (BTW, going to sleep now, will continue tommorrow)

OK, me too. :)

-- 
 KOVACS Krisztian
