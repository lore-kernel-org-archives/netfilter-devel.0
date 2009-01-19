From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Add IP_OPTIONS to IP header using netfilter
Date: Mon, 19 Jan 2009 21:31:09 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901192122160.12940@fbirervta.pbzchgretzou.qr>
References: <c0549e500801072158y6707924eg3d27289b076c8375@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Ashwini R <ashwinir.11@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58836 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZASUbK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:31:10 -0500
In-Reply-To: <c0549e500801072158y6707924eg3d27289b076c8375@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-01-08 06:58, Ashwini R wrote:
>
>struct ip_options *opt = kzalloc(sizeof(struct ip_options) + ((srlen +
>3) & ~3), GFP_KERNEL);
>memcpy(opt->__data, srp, srlen);
>
>But, I am not sure how to add this new ip_options to the captured
>packet since I need to append the ip_options structure to the ip
>header of the packet.

You basically have to rebuild the IP packet. How exactly you do it
(#1 or #2) is up to you.

#1. Create new packet of appropraite size, copy IP header,
put options in place, copy payload.
#2. Cloning packet, expanding packet size, moving payload forwards,
adding IP options in the appropriate place.

>Also, I am not sure how to specify the new packet length, if I need to
>recompute the checksum, etc.

I think skb_realloc_headroom is needed here...


/* GFP_KERNEL only allowed on LOCAL_OUT and POST_ROUTING */
nskb = skb_realloc_headroom(skb, size_of_your_option_data, 0, GFP_KERNEL);

void *oiph = ip_hdr(skb);
void *niph = skb_push(skb, size_of_your_option_data);
memmove(niph, oiph, sizeof(struct iphdr) + size_of_existing_options);

then fill in the space that just got vacant with your new options.
Afterwards recalculate checksum.
