From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 16:13:03 +0200
Message-ID: <434BC86F.3090506@cosmosbay.com>
References: <20051010164141.GG5627@rama>	<20051010.141518.60492651.davem@davemloft.net>	<20051010214619.GJ5627@rama>
	<Pine.LNX.4.61.0510111550170.2575@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510111550170.2575@filer.marasystems.com>
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

Henrik Nordstrom a =E9crit :
> On Mon, 10 Oct 2005, Harald Welte wrote:
>=20
>> I don't know why they are incomplete ;)  My guess is that they're most=
ly
>> targeted to per_cpu users.  Basically to solve the 'iptables' problem,
>> there are two ways:
>=20
>=20
> Or three.
>=20
>   3) Keep an NUM_CPUS array of pointers to the per-cpu tables, allocate=
d=20
> separately per CPU instead of allocating a single large blob for all=20
> CPUs. These pointers are updated using RCU, and indexed using the=20
> physical CPU id.
>=20

Yes, this is what I suggested some weeks ago with a patch.

As vmalloc_node() is not yet part of kernel, I even coded a substitute fo=
r it.
(per_cpu/kmalloc are not an option since the allocations done in iptables=
 can=20
be very large)

http://marc.theaimsgroup.com/?l=3Dlinux-netdev&m=3D112733887410796&w=3D2


> Cost: One (most likely cached) indirect memory access on each packet,=20
> and slightly more complex update procedure (num_possible_cpus=20
> allocations and pointers to update instead of just one).
>=20
> Regards
> Henrik
>=20
>=20
