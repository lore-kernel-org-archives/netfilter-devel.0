Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC5EC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Oct 2023 08:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjJ3Iiu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Oct 2023 04:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjJ3Iit (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Oct 2023 04:38:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9204AA7;
        Mon, 30 Oct 2023 01:38:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-27e0c1222d1so2746027a91.0;
        Mon, 30 Oct 2023 01:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698655127; x=1699259927; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIJZsc0cgq2Yj9yNo8faOgPCZmuoXrx5otYy0EkayaU=;
        b=ROqysX8/cSMc1ZYKCJpWqeGJljQVFznpcBWMMbM0xBxs7o4EE70tMdQOVTvHUs8SpZ
         iJJ/A5ksSOMMbaTzSo6Zt0AKqqH3U4IOc6B3V5vFozCyxFJqFm95si0++N6ayaGdFkEN
         msMs1RA+5P2cPMo+oosob86wVrlAOjFRuE+wV3+Xr4zAW1Is40pXfng0WsiiSy7O35oy
         mvewwspRnR4r02sh82ZvkfzkRbc20M+gw9oVopr8yQWWjlLthdjwIttjezRBbapyXFLb
         VFMxJ7AWfK1wEABp4kA/bA/xQD2dnv3/T9Ss7z+1PgZqM89kc8QkR5fqf4UkiqiM7tty
         zYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698655127; x=1699259927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIJZsc0cgq2Yj9yNo8faOgPCZmuoXrx5otYy0EkayaU=;
        b=qdpeKWM3AoMlpg4PFBljfkhDhJ3YcdHIaj0f38NWKlaeUcSwckdx5beJJky7C2rU0C
         nSKZjw29aQvrvIjYyPidV7GjovPvfETtn1SwiuDzeOstVaeQU0lZeOAM1X5f35lkqG0t
         uOzH3sFdMH90pNunYaKiXsQh3s/YjdYAL8CUSZ/vjufNvVABZr1wYo/l49oLEiVwudBH
         arIiptSQXC2XNWh14C4Uw+Vkw7HtuiFgPDWvq9ulH5DrHOhLBXZKXQnK81q+GXXiVGgC
         Xd+btxFopcRAtrVtdVMMFicLc37TEFE1iBCpjHYNU7pYyXE3/HAPMea1UsTJcG+V7L/v
         coZA==
X-Gm-Message-State: AOJu0YzrAP6ZwFajLVvkBOphZ4PB8mWJB/efcLES24nNLeEzaQFmc4Fj
        qSGmz5mCOdqjL6HT0VP4WNk=
X-Google-Smtp-Source: AGHT+IEgAsk6Pr2yTS6DIeP2R5UiKvd/XA6m5Go89YS81CcCyBFgmYMZz2+swhzs71/WGyAt+2MVZw==
X-Received: by 2002:a17:90a:1a50:b0:27d:3296:b3e with SMTP id 16-20020a17090a1a5000b0027d32960b3emr6159143pjl.41.1698655126959;
        Mon, 30 Oct 2023 01:38:46 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c11-20020a17090a020b00b00256b67208b1sm2560039pjc.56.2023.10.30.01.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 01:38:45 -0700 (PDT)
Date:   Mon, 30 Oct 2023 16:38:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [RFC Draft PATCHv2 net-next] Doc: update bridge doc
Message-ID: <ZT9rkYsR0F3M+IxU@Laptop-X1>
References: <20231027071842.2705262-1-liuhangbin@gmail.com>
 <ZTutokxEXya0rqYs@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTutokxEXya0rqYs@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Thanks Florian, very appreciate for your comments. I'm not familiar with
the bridge netfilter history and usage. I will summary and update the doc
with your comments in next version(with the other's comments).

Hope you could review it again.

Regards
Hangbin

On Fri, Oct 27, 2023 at 02:31:30PM +0200, Florian Westphal wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> [ cc nf-devel ]
> 
> > The current bridge kernel doc is too old. It only pointed to the
> > linuxfoundation wiki page which lacks of the new features.
> 
> Indeed, thanks for taking time to improve the documention.
> 
> > +Netfilter
> > +=========
> > +
> > +The bridge netfilter module allows packet filtering and firewall functionality
> > +on bridge interfaces. As the Linux bridge, which traditionally operates at
> > +Layer 2 and connects multiple network interfaces or segments, doesn't have
> > +built-in packet filtering capabilities.
> 
> No, this is not what this module does.  br_netfilter module should NEVER
> be used.  I'd love to remove it, but its very popular unfortunately.
> 
> Suggestion:
> 
> The bridge netfilter module is a legacy feature that allows to filter bridged
> packets with iptables and ip6tables.  Its use is discouraged.  Users
> should consider using nftables for packet filtering.
> 
> The older ebtables tool is more feature-limited compared to nftables, but
> just like nftables it doesn't need this module either to function.
> 
> The br_netfilter module intercepts packets entering the bridge, performs
> minimal sanity tests on ipv4 and ipv6 packets and then pretends that
> these packets are being routed, not bridged.  br_netfilter then calls
> the ip and ipv6 netfilter hooks from the bridge layer, i.e. ip(6)tables
> rulesets will also see these packets.
> 
> br_netfilter is also the reason for the iptables 'physdev' match:
> This match is the only way to reliably tell routed and bridged packets
> apart in an iptables ruleset.
> 
> Side note:
> 
> You might want to somehow massage the bits below, perhaps it would be
> good to have the historical context as to why br_netfilter exists in the
> first place.
> 
> > +With bridge netfilter, you can define rules to filter or manipulate Ethernet
> > +frames as they traverse the bridge. These rules are typically based on
> > +Ethernet frame attributes such as MAC addresses, VLAN tags, and more.
> > +You can use the *ebtables* or *nftables* tools to create and manage these
> > +rules. *ebtables* is a tool specifically designed for managing Ethernet frame
> > +filtering rules, while *nftables* is a more versatile framework for managing
> > +rules that can also be used for bridge filtering.
> 
> ebtables and nftables will work fine without the br_netfilter module.
> 
> iptables/ip6tables/arptables do not work for bridged traffic because they
> plug in the routing stack.
> 
> nftables rules in ip/ip6/inet/arp families won't see traffic that is
> forwarded by a bridge either, but thats very much how it should be.
> 
> br_netfilter is only needed if users, for some reason, need to use
> ip(6)tables to filter packets forwarded by the bridge, or NAT bridged
> traffic.
> 
> Historically the feature set of ebtables was very limited (it still is),
> so this module was added to pretend packets are routed and invoke the
> ipv4/ipv6 netfilter hooks from the bridge so users had access to the
> more feature-rich iptables matching capabilities (including conntrack).
> 
> nftables doesn't have this limitation, pretty much all features work
> regardless of the protocol family.
> 
> > +The bridge netfilter is commonly used in scenarios where you want to apply
> > +security policies to the traffic at the data link layer. This can be useful
> > +for segmenting and securing networks, enforcing access control policies,
> > +and isolating different parts of a network.
> 
> See above, for pure link layer filtering, this module isn't needed.
