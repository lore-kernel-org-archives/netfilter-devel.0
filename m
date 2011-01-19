From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 01/12] IP set core support
Date: Wed, 19 Jan 2011 17:24:52 +0100
Message-ID: <1295454292.3273.21.camel@edumazet-laptop>
References: yes <1295047436-20702-1-git-send-email-kadlec@blackhole.kfki.hu>
	 <1295047436-20702-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46414 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab1ASQbh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:31:37 -0500
Received: by fxm20 with SMTP id 20so1058451fxm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jan 2011 08:31:36 -0800 (PST)
In-Reply-To: <1295047436-20702-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le samedi 15 janvier 2011 =C3=A0 00:23 +0100, Jozsef Kadlecsik a =C3=A9=
crit :

> +/* Allocate members */
> +static inline void *
> +ip_set_alloc(size_t size, gfp_t gfp_mask)
> +{
> +	void *members =3D NULL;
> +
> +	if (size < KMALLOC_MAX_SIZE)
> +		members =3D kzalloc(size, gfp_mask | __GFP_NOWARN);
> +
> +	if (members) {
> +		pr_debug("%p: allocated with kmalloc", members);
> +		return members;
> +	}
> +
> +	members =3D __vmalloc(size, gfp_mask | __GFP_ZERO, PAGE_KERNEL);
> +	if (!members)
> +		return NULL;
> +	pr_debug("%p: allocated with vmalloc", members);
> +
> +	return members;
> +}
> +

Note : We now have vzalloc(), no need to use __vmalloc() (BTW
__GFP_HIGHMEM is missing)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
