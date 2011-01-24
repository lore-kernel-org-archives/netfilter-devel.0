From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition
 between dump_table and destroy
Date: Mon, 24 Jan 2011 14:12:02 +0100
Message-ID: <1295874722.2755.25.camel@edumazet-laptop>
References: <20110123231602.3383.31480.stgit@decadence>
	 <1295851305.28358.16.camel@edumazet-laptop>
	 <4D3D691F.3050403@netfilter.org> <4D3D74AD.5080300@trash.net>
	 <1295873689.2755.22.camel@edumazet-laptop> <4D3D794D.9010401@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38954 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1AXNMI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:12:08 -0500
Received: by wyb28 with SMTP id 28so4042785wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jan 2011 05:12:06 -0800 (PST)
In-Reply-To: <4D3D794D.9010401@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 24 janvier 2011 =C3=A0 14:06 +0100, Pablo Neira Ayuso a =C3=A9=
crit :

> Yes, we can use nf_conntrack_get (which does atomic_inc) instead. New
> patch attached.

I feel now a bit uncomfortable, sorry ;)

Are we sure the refcount cannot reach 0 while we hold
nf_conntrack_lock ?



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
