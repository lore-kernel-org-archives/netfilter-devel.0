From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [RFC] don't copy the whole table to all the other CPUs
Date: Wed, 17 Nov 2010 15:57:40 +0100
Message-ID: <1290005860.2687.36.camel@edumazet-laptop>
References: <AANLkTinBSZPAMKb7J0aBb4_xBv_QPnXTZAE9c+8=cnHz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44822 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab0KQO6L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:58:11 -0500
Received: by wwa36 with SMTP id 36so2115098wwa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2010 06:58:10 -0800 (PST)
In-Reply-To: <AANLkTinBSZPAMKb7J0aBb4_xBv_QPnXTZAE9c+8=cnHz@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 17 novembre 2010 =C3=A0 22:54 +0800, Changli Gao a =C3=A9cr=
it :
> When reviewing the iptables code, I find there is one exact copy of
> table on every possible CPU for parallel processing. However, only
> counters are private, and the others are the same. It is a wast of
> memory. I know the current implementation maybe good for NUMA, but I
> don't think NUMA is common, and I doubt its benefit. I'll try to
> convert the code use one shared table, but private counters.
>=20
> Any comment?
>=20

This idea is not new, and I believe Patrick is already working on it.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
