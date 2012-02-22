From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/3] net/netfilter: refactor notifier registration
Date: Wed, 22 Feb 2012 08:54:20 +0100
Message-ID: <1329897260.18384.86.camel@edumazet-laptop>
References: <1329893281-508699-1-git-send-email-antonz@parallels.com>
	 <1329893281-508699-3-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Tony Zelenoff <antonz@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51180 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2BVHy0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:54:26 -0500
Received: by wics10 with SMTP id s10so4007555wic.19
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2012 23:54:25 -0800 (PST)
In-Reply-To: <1329893281-508699-3-git-send-email-antonz@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 22 f=C3=A9vrier 2012 =C3=A0 10:48 +0400, Tony Zelenoff a =C3=
=A9crit :
> * ret variable initialization removed as useless
> * Similar code strings concatenated and functions code
>   flow became more plain
>=20
> Signed-off-by: Tony Zelenoff <antonz@parallels.com>
> ---
>  net/netfilter/nf_conntrack_ecache.c |   26 ++++++++++---------------=
-
>  1 files changed, 10 insertions(+), 16 deletions(-)
>=20
> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_c=
onntrack_ecache.c
> index aa15977..9b8e986 100644
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -81,21 +81,18 @@ EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
>  int nf_conntrack_register_notifier(struct net *net,
>  				   struct nf_ct_event_notifier *new)
>  {
> -	int ret =3D 0;
> +	int ret;
>  	struct nf_ct_event_notifier *notify;
> =20
>  	mutex_lock(&nf_ct_ecache_mutex);
>  	notify =3D rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
>  					   lockdep_is_held(&nf_ct_ecache_mutex));
> -	if (notify !=3D NULL) {
> +	if (likely(!notify)) {
> +		rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
> +		ret =3D 0;
> +	} else
>  		ret =3D -EBUSY;
> -		goto out_unlock;
> -	}
> -	rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
> -	mutex_unlock(&nf_ct_ecache_mutex);
> -	return ret;
> =20
> -out_unlock:
>  	mutex_unlock(&nf_ct_ecache_mutex);
>  	return ret;
>  }
> @@ -118,21 +115,18 @@ EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notif=
ier);
>  int nf_ct_expect_register_notifier(struct net *net,
>  				   struct nf_exp_event_notifier *new)
>  {
> -	int ret =3D 0;
> +	int ret;
>  	struct nf_exp_event_notifier *notify;
> =20
>  	mutex_lock(&nf_ct_ecache_mutex);
>  	notify =3D rcu_dereference_protected(net->ct.nf_expect_event_cb,
>  					   lockdep_is_held(&nf_ct_ecache_mutex));
> -	if (notify !=3D NULL) {
> +	if (likely(!notify)) {
> +		rcu_assign_pointer(net->ct.nf_expect_event_cb, new);
> +		ret =3D 0;
> +	} else
>  		ret =3D -EBUSY;
> -		goto out_unlock;
> -	}
> -	rcu_assign_pointer(net->ct.nf_expect_event_cb, new);
> -	mutex_unlock(&nf_ct_ecache_mutex);
> -	return ret;
> =20
> -out_unlock:
>  	mutex_unlock(&nf_ct_ecache_mutex);
>  	return ret;
>  }

Please leave the code as is, I find it more readable.

It is standard coding practice, and permits stacking of new init code,
with proper error path.

Dont add likely()/unlikely() clauses in slow path, this obfuscate code
for litle gain.




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
