From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Thu, 2 Jun 2016 22:24:40 +0800
Message-ID: <20160602142440.GE30064@insomnia>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602115439.085385545@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2016 at 01:52:02PM +0200, Peter Zijlstra wrote:
[snip]
> --- a/arch/powerpc/include/asm/spinlock.h
> +++ b/arch/powerpc/include/asm/spinlock.h
> @@ -27,6 +27,8 @@
>  #include <asm/asm-compat.h>
>  #include <asm/synch.h>
>  #include <asm/ppc-opcode.h>
> +#include <asm/barrier.h>
> +#include <asm/processor.h>
> =20
>  #ifdef CONFIG_PPC64
>  /* use 0x800000yy when locked, where yy =3D=3D CPU number */
> @@ -165,8 +167,10 @@ static inline void arch_spin_unlock(arch
>  #ifdef CONFIG_PPC64
>  extern void arch_spin_unlock_wait(arch_spinlock_t *lock);
>  #else
> -#define arch_spin_unlock_wait(lock) \
> -	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
> +static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
> +{
> +	smp_cond_load_acquire(&lock->slock, !VAL);
> +}
>  #endif
> =20

About spin_unlock_wait() on ppc, I actually have a fix pending review:

http://lkml.kernel.org/r/1461130033-70898-1-git-send-email-boqun.feng@gmail=
=2Ecom

that patch fixed a different problem when people want to pair a
spin_unlock_wait() with a spin_lock().

I think we still need that fix, and there are two conflicts with this
series:

1.	arch_spin_unlock_wait() code for PPC32 was deleted, and
	consolidated into one.

2.	I actually downgraded spin_unlock_wait() to !ACQUIRE ;-)


I can think of two ways to solve thoes conflicts:

1.	Modify my patch to make spin_unlock_wait() an ACQUIRE, and it
	can be merged in powerpc tree, and possible go into to mainline
	before 4.7. Then there is no need for this series to have code
	for ppc, therefore no conflict.

or

2.	I can rebase my patch on this series, and it can be added in
	this series, and will go into mainline at 4.8.


Michael and Peter, any thought?

Regards,
Boqun

>  /*

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXUEGiAAoJEEl56MO1B/q4C7cH/33evgT/8w9kToBwin+GWNYh
n+fvTt1p9J/nH53IBBzRNezqvIEa2M2tgeErQObsss7qnVQmzSmJqaqjKAfsRvxv
A3eCorQPlsH0P+Gkwl3jouCLKvpBy/XwAOAh8cTpk5V3ujSkxlTfoQjKq/w/s1fC
aHiiA5jCVWtrng03VsAhHdhpbvuvqQWg9nKxCg7sPoSzS+nnCov4GNiV3U5TsymK
ClavNr+Vxe1/wT84nGEsVConKfaLwk8Z1tPFP+F1xN29/RqO+q1+jfMA9I+qc2PC
C35RFcdPyO3ILrqVcewVMA6nThxveVNmfquyw6sHHYX1M9lBNgcTG0X0vo2BqDc=
=v9Pb
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
