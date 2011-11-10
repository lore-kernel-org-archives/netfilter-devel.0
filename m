From: Paul Guo <ggang@tilera.com>
Subject: Re: unaligned ip header due to ip_route_me_harder()->pskb_expand_head()
Date: Thu, 10 Nov 2011 15:33:16 +0800
Message-ID: <4EBB7E3C.9030402@tilera.com>
References: <4EB9449D.8020701@tilera.com>  <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4EBA48F3.8040906@tilera.com> <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([206.83.70.75]:38937 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1KJHdX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Nov 2011 02:33:23 -0500
In-Reply-To: <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Le mercredi 09 novembre 2011 =C3=A0 17:33 +0800, Paul Guo a =C3=A9cri=
t :
>=20
>>> or=20
>>>
>>> pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)), 0,=
 GFP_ATOMIC))
>>
>> Thanks. This looks better.
>=20
> Could you submit an official patch ?
>=20
> Thanks !

OK. I tried to clone a netfilter branch firstly, but failed. Cloning th=
e network
branch is OK. It looks there is something wrong with the netfilter git =
branch,
or am I doing something wrong? Thanks.

# git clone git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-=
2.6.git
Initialized empty Git repository in /u/ggang/recent/netfilter-git/nf-2.=
6/.git/
fatal: The remote end hung up unexpectedly

# git clone git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
Initialized empty Git repository in /u/ggang/recent/net-git/net/.git/
remote: Counting objects: 2233147, done.
remote: Compressing objects: 100% (354952/354952), done.
Receiving objects:   4% (110532/2233147), 40.82 MiB | 343 KiB/s


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
