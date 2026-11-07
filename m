Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794047343;
	b=ozmj1T05o15WZ7i+WjskYPcSJfSlPIOUOK27/99ziwL1AEpMG6UcB63YpZ8FOR/BSXDE
	 1C3N5BBblJ2Tr2xySopZoitIm4K/UTBpWunE622M5uSgX0/y3eZl5d80Ve3ivCfwkyQUO
	 nQpW6t65cMALNCfPIWjTBWF0uuzSLiaLb0QIFoqGby2aKGTg1KtM4Z2OR6JaUoJDRfaFS
	 M+NFX/uMuchCe6K6xrs2vaYhMcocGNpXtF0WR3OGJRjcGJLUq/WB7I2OBF75a4ghh8QcX
	 w/HmJy/17M7+ZZgADcAUezY7vYsRyMHv6jOMZyBs8wOnn6Y6/6lxeyRg/l+fwpJcLSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794047343;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=kPfxxEoDedkpzijCZq5OLG208Bd3QgI6noPt3uH0hgY=;
	b=KVA83tZHMvuwG6Cw5wncwZD6g37LazDAXhoQzJMiwsmxecyudd7x33TkkKjFOXLNSXf5
	 xp80X5l27GBjSS994gsuvFVrlhg0+pjQabLpdoFoLMXq+MhoR1XOxdwdS+86vaM3G5y/t
	 ldE3LDiy7+OAKnGYSFgDfFOHdOMGO+ANvONqkh/i1qXIa5llmx7yF9bgWKrtoPeefTHEW
	 KrzjS5qRJ4umw0BXEXxxYXl2GBqE68LeFmDdwMJ1691cmsLjDlK33PBTXt3+32Osq6VYs
	 R0GSmX5jXhDnkj9WBZduAOl1q/O/pY9WfxHeSD36HEiGjXr0Rm/2Cc9+tlLxECbE9lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=gU8fV7MN;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665EC606A33A
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Nov 2026 10:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 665EC606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=gU8fV7MN
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53bb57f1310so17572201cf.2
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Nov 2026 02:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1794047342; x=1794652142; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kPfxxEoDedkpzijCZq5OLG208Bd3QgI6noPt3uH0hgY=;
        b=gU8fV7MN8HJRfR0yKPGughXHLXj/wm9K6t0J7Vdu8qZjnVIQY+xLkiocbpG0MrNr5c
         UJ/rhNua6yMK7CDQPNtNFEeztgoR6MjAAH8ImfZ2SueDr+PyiWGwpEjLxCZfuMOvmU6L
         8i/27wDm8zx09wa5f2dtbZpPBiE2L9eSQ/XpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794047342; x=1794652142;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kPfxxEoDedkpzijCZq5OLG208Bd3QgI6noPt3uH0hgY=;
        b=alVMnC/u73Irs7P4Qg1uyN56S8XTywTJl5rI3iNUITf2tunk4YOmxBMOsqwdNNO8bu
         qz83/iXr6x5Mpr3RX0l/kY+H0p1XRQW8gE1DNFIbiFawAQuWsBtjhyjHMNTXSyr6wZaO
         xuzx5kaoPoaM8D6/6P/gk16Scsz9dD0o7f82QWMJtw4DyGedbBVvZIgwUJE9iHrZyiCQ
         pQrZNU4XigE79yl0DWijoyyJUEeS7iOYgc94qeM6so+oJhD2V9sOAoKGS+vtq0C3eMQB
         oshLUxMc3lbgEN6ZbTgYwfuI/8LEeJw/oCc3uYLSoil64fJuPJhsuAonDPhSsz0E25nC
         x0KA==
X-Gm-Message-State: APuU4Z/6VtrF8prsdIgQTTRIfKHAnDx1AqG2nshxrLTEOl+vllr9O6YB
	UK5a3PzZ0/LwJn/KzswJLzD7+Osw/+f9BpNQ4YVBxKdeHxq/TiBdFD+JeDYy0E0CRXl9iodCWvd
	g8XHz2m8=
X-Gm-Gg: AYBFou1cRJ19JwomoovXMFPIvRz0jWtoU71ra9NBXI7J5nItS3UzbJkKRia04UUnxCB
	Kh+dl7xw9v1zyfDMSg5yyvcV7Ql2qJr54NtOlaLQIduNnXtSsW9NDbGU916/5l/Xewvz75ijT6n
	1Ve0Q66yRt8yLlx8Bj1X6630AO00U7P43T+S6iPzqSQIs+NXQqX1H3w2keTrfw4qjvXQOYVFMFm
	7O6l1RUUe3sf1V0xWtW7wflmBhVqk0a1dQOKXRJ68dPxnEfsTLu5DdQQdp3dkLd6Cueh4RmA/O/
	s9zfWDWzR8jMSmtf097ORA6YvJyV40DR35Vm7MYVIPAr8A4gteDeL08WS291+sKg/ECv8ruf/M7
	0wBdkwrDLlXFQmAvJO5TY/pHauH0/qUYZs9uVO2ZyVdlHAYT+uMuuDgepYggm7e1zbx/mko5niq
	O+7MC9AsZ/e/EHl/asVjVYZyicpzeWSaO2kXRhcr6whBsqy6vJG+h1TVnX5YqT76npi5SU9aiV2
	9DvSTlcMHRYFmODZ5Orjvifi0KfAN/TF2ZIs4oWUnfr2ERyow3pa2QSNBozwm39RPQzTj9eRIAY
	/Jl2LHxqTwWMYeaMTynlDdKuNaM7OTi5tFBF/b0zg5YJeI5khJ5XD+xy83OAlXvo3k4hl/Xxh77
	nat5/XpE=
X-Received: by 2002:a05:622a:2508:b0:537:dea7:adb1 with SMTP id d75a77b69052e-54e115b4283mr77969511cf.4.1794047342290;
        Sat, 07 Nov 2026 02:29:02 -0800 (PST)
Received: from com-75606 ([199.47.143.1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e2625abafsm43098871cf.16.2026.11.07.02.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 02:29:02 -0800 (PST)
Date: Sat, 7 Nov 2026 02:28:58 -0800
From: Kyle Zeng <kylebot@openai.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Subject: Re: [PATCH] netfilter: br_netfilter: reject unsafe neighbour devices
 for DNAT
Message-ID: <au79avuyDAz__s4t@com-75606>
References: <20261030042155.73844-1-kylebot@openai.com>
 <au7SdYQrIqAQOU24@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <au7SdYQrIqAQOU24@strlen.de>

On Sat, Nov 07, 2026 at 08:25:41AM +0100, Florian Westphal wrote:
> Kyle Zeng <kylebot@openai.com> wrote:
> > The IPv4 and IPv6 bridge prerouting callbacks classify DNAT traffic using
> > the logical input device saved in skb->dev. The physical input port can
> > have a different bridge master when prerouting resumes, for example after
> > an NFQUEUE verdict. Netfilter reassembly can also combine the first
> > fragment's bridge information with a different fragment's input device.
> > 
> > br_nf_pre_routing_finish_bridge() replaces skb->dev with the port's
> > current bridge master, but looks up the neighbour using the existing
> > route. This can put an skb with skb->dev pointing to bridge B on an
> > unresolved neighbour of bridge A. Deleting B and resolving the neighbour
> > on A then causes a use-after-free in __dev_queue_xmit().
> > 
> > Before calling the neighbour output method, check that the neighbour
> > keeps skb->dev alive. A neighbour holds its device, and a VLAN device
> > also holds its real device, so allow a VLAN whose real device is the
> > bridge. Release the neighbour and drop the skb on a mismatch.
> > 
> > Doing this in the shared continuation covers both protocol families,
> > including a queue in the remaining bridge prerouting hooks. Leave the
> > cached-header path unchanged since it does not enqueue the skb.
> > 
> > Signed-off-by: Kyle Zeng <kylebot@openai.com>
> > ---
> > I have a reproducer for this issue and can share via DM
> > 
> >  net/bridge/br_netfilter_hooks.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> > index e15355ff215a..726a2d17ed3a 100644
> > --- a/net/bridge/br_netfilter_hooks.c
> > +++ b/net/bridge/br_netfilter_hooks.c
> > @@ -307,6 +307,18 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
> >  
> >  			ret = br_handle_frame_finish(net, sk, skb);
> >  		} else {
> > +			struct net_device *dev = neigh->dev;
> > +
> > +			/* The neighbour queue must keep skb->dev alive. A VLAN
> > +			 * device also holds a reference to its real device.
> > +			 */
> > +			if (is_vlan_dev(dev))
> > +				dev = vlan_dev_real_dev(dev);
> > +			if (dev != skb->dev) {
> > +				neigh_release(neigh);
> > +				goto free_skb;
> > +			}
> > +
> 
> I don't understand the vlan check. Why is that needed?
> The call to br_nf_pre_routing_finish_bridge is gated via:
> 
>  405                         if (skb_dst(skb)->dev == dev) {
>  406                                 skb->dev = br_indev;
>  407                                 nf_bridge_update_protocol(skb);
>  408                                 nf_bridge_push_encap_header(skb);
>  409                                 br_nf_hook_thresh(NF_BR_PRE_ROUTING,
>  410                                                   net, sk, skb, skb->dev,
>  411                                                   NULL,
>  412                                                   br_nf_pre_routing_finish_bridge);
> 
> 
> ... so this patch ought to be sufficient?
> 
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -283,6 +283,10 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
>         if (!skb->dev)
>                 goto free_skb;
>         dst = skb_dst(skb);
> +
> +       if (dst->dev != skb->dev)
> +               goto free_skb;
> +
>         neigh = dst_neigh_lookup_skb(dst, skb);
> 
> (I can't see how neigh->dev != skb->dev after the extra test).


The VLAN check is intended to preserve existing VLAN DNAT behavior.

bridge-nf-filter-vlan-tagged=1, bridge-nf-pass-vlan-input-dev=1, and br0.100, the earlier test can pass with
dst->dev == dev == br0.100. The continuation then changes skb->dev to br0, so the strict comparison would
drop that valid packet.

A neighbour on br0.100 is safe here because it holds the VLAN device, which holds its underlying bridge. That is why the slow-path check compares the neighbour´s underlying device with skb->dev.
