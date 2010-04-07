From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
	lookup by id
Date: Wed, 7 Apr 2010 21:42:23 +0800
Message-ID: <o2v412e6f7f1004070642u2a414b82w9262fce18f162b30@mail.gmail.com>
References: <4BBBFE21.9070507@gmail.com> <4BBC711E.7050602@trash.net>
	<1270643136.2091.1013.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:33239 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab0DGNmu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:42:50 -0400
Received: by iwn35 with SMTP id 35so501649iwn.21
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Apr 2010 06:42:48 -0700 (PDT)
In-Reply-To: <1270643136.2091.1013.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 7, 2010 at 8:25 PM, Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
>
> Yes, a hash table would be good, but cost 8 bytes per slot.
>
> Changli, did you tried RBL tree ? It might fit better both your needs
> and Patrick concerns...

I don't think rbtree is better than idr. rbtree's time complexity is
O(log2(n)), but idr is a kind of radix tree with O(1) time complexity.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
