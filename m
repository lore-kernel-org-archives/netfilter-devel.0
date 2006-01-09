From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Mon, 09 Jan 2006 12:23:59 +0100
Message-ID: <43C247CF.2000608@cosmosbay.com>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald Welte a =E9crit :
> Hi!
>=20
> It's been some time since I last released a version of the x_tables
> patch.  This is mainly due to the reason that 2.6.15 has only been
> released recently, and x_tables was clearly 2.6.16 work.
>=20
> I've modified nfsim and the nfsim-testsuite to work with an x_tables
> kernel, and all tests now pass without any problem (using an old
> iptables binary that was compiled against a non-xtables kernel). This,
> in addition to my manual tests, give me enough confidence that I didn't
> break something significant.
>=20
> I'm planning to submit x_tables eatly next week, so this is assumed to
> be the final review phase.
>=20
> So if you have any issues, please comment now before it's too late :)
>=20
Hi Harald

Is there any chance we can get rid of the rwlock_t lock in 'struct xt_tab=
le' ?
(Replacing it by an array of spinlocks)

     /* Lock for the curtain */
-   rwlock_t lock;
+   spinlock_t *lockp;



Pros :

   1) No more cache line ping pongs between cpus. A read_lock_bh(&table->=
lock)=20
is still expensive because of that.

   2) spinlocks are less expensive (spin_unlock is not an atomic op like=20
read_unlock_bh()

On a dual processor machine, its quite common that all incoming frames ar=
e=20
handled by CPU 0, while CPU 1 is doing the User level stuff and sends net=
work=20
trafic...

Thank you

( I had a patch sent in September which was doing quite the same thing on=
=20
ipt_tables, but keeping the rwlock_t : Correct me but I think we can just=
 use=20
spinlocks)

Eric
