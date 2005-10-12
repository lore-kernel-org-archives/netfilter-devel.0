From: seb@frankengul.org
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Wed, 12 Oct 2005 08:22:18 +0200
Message-ID: <20051012062218.GA2712@frankengul.org>
References: <20051011104446.GJ4290@rama>
	<20051011175457.GC13415@rama.de.gnumonks.org>
	<434C3485.2000700@frankengul.org>
	<20051011.153257.75932845.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051011.153257.75932845.davem@davemloft.net>
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

On Tue, Oct 11, 2005 at 03:32:57PM -0700, David S. Miller wrote:
> From: S=E9bastien Bernard <seb@frankengul.org>
> Date: Tue, 11 Oct 2005 23:54:13 +0200
>=20
> > On sparc64, cpu_possible_map does not exist.
>=20
> Yes, it does, although indirectly.  Otherwise for_each_cpu() would be
> horrible broken and never allow building sparc64 SMP kernels :-)
>=20
> It's defined in kernel/sched.c for non-SMP and defined to
> phys_cpu_present_map when SMP.
>=20
> Did you try to build his patch and it actually failed?  If so, please
> post the build failure instead of speculation about why it failed so
> that this can be properly analyzed :-)
>=20

It is no speculation.
After building, the modules_install reports the symbol undefined.
Well, I see now that it is only a lack of EXPORT_SYMBOL.
I was checking other arch.
All smp arch used cpu_online_map and cpu_possible_map but sparc which
used phys_cpu_present_map (a specificity of the sparc port I presume).

Anyway, it's on its way now.

	Seb
