From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition
 between dump_table and destroy
Date: Mon, 24 Jan 2011 19:01:02 +0100
Message-ID: <1295892063.2755.37.camel@edumazet-laptop>
References: <20110123231602.3383.31480.stgit@decadence>
	 <1295851305.28358.16.camel@edumazet-laptop>
	 <4D3D691F.3050403@netfilter.org> <4D3D74AD.5080300@trash.net>
	 <1295873689.2755.22.camel@edumazet-laptop> <4D3D794D.9010401@netfilter.org>
	 <1295874722.2755.25.camel@edumazet-laptop> <4D3D7DD5.9020902@netfilter.org>
		  <4D3D809F.30808@trash.net> <1295877971.2755.30.camel@edumazet-laptop>
	  <4D3DBC94.3090505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56904 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab1AXSBI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:01:08 -0500
Received: by bwz15 with SMTP id 15so3820490bwz.19
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jan 2011 10:01:06 -0800 (PST)
In-Reply-To: <4D3DBC94.3090505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 24 janvier 2011 =C3=A0 18:53 +0100, Patrick McHardy a =C3=A9cr=
it :

> No, that can't happen. Before the last refcount is released, the entr=
y
> is removed from the hash, which requires to take the lock. Each entry
> contained in the hash table has a refcount of at least 1.
>=20
> If there are no futher concerns, I'm going to apply Pablo's patch.

Thanks, that's perfect by me

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
