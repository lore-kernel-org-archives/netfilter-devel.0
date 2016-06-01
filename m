From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH -v3 3/8] locking: Introduce smp_acquire__after_ctrl_dep
Date: Wed, 1 Jun 2016 21:52:14 +0800
Message-ID: <20160601135214.GC30064@insomnia>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.037298593@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34854 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbcFANsl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 09:48:41 -0400
Content-Disposition: inline
In-Reply-To: <20160531094844.037298593@infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 31, 2016 at 11:41:37AM +0200, Peter Zijlstra wrote:
[snip]
> @@ -260,16 +260,6 @@ static void sem_rcu_free(struct rcu_head
>  }
> =20
>  /*
> - * spin_unlock_wait() and !spin_is_locked() are not memory barriers, they
> - * are only control barriers.
> - * The code must pair with spin_unlock(&sem->lock) or
> - * spin_unlock(&sem_perm.lock), thus just the control barrier is insuffi=
cient.
> - *
> - * smp_rmb() is sufficient, as writes cannot pass the control barrier.
> - */
> -#define ipc_smp_acquire__after_spin_is_unlocked()	smp_rmb()
> -
> -/*
>   * Wait until all currently ongoing simple ops have completed.
>   * Caller must own sem_perm.lock.
>   * New simple ops cannot start, because simple ops first check
> @@ -292,7 +282,7 @@ static void sem_wait_array(struct sem_ar
>  		sem =3D sma->sem_base + i;
>  		spin_unlock_wait(&sem->lock);
>  	}
> -	ipc_smp_acquire__after_spin_is_unlocked();
> +	smp_acquire__after_ctrl_dep();

I wonder whether we can kill this barrier after updating
spin_unlock_wait() to ACQUIRE?

Regards,
Boqun

>  }
> =20
>  /*

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXTuiLAAoJEEl56MO1B/q4SKsH/AxF1JnFmXdDZ+dQ8EIgdVfl
UzyAImRyScdAWTngSdF4pbDnCTJohWkWfAJ8Q1m93lcSqHFYomykwK8hZSGs9dvg
c6JId2f4UjiGZ7QXz/xdoDWFFm9EI/F4SUrNGax34kvzlNOwtdIGuZbTIbZHq70I
BtMpIkFJiq16DZjX/CB/H3YCXjAey/B0IuKwYCiM9H8cNa+OeNwAEN4QxiPnx4mk
H2tvy+xgLW7PiZtDJAzocZVyEqaxPk2O21z3WGHOeLkr2IRJoSTsHPZ17GaiGAWn
AKyUJlkzl2/jQRq7isqMvpy8WJFnRx1pWtzytOImTpKnm/F7q7vxL7HWHwq0LaU=
=kAwJ
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
