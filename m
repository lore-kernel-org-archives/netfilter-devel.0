From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] x_tables : Use SMP friendly (percpu) rwlock_t to protect
 x_tables
Date: Fri, 27 Jan 2006 22:51:42 +0100
Message-ID: <43DA95EE.6040909@cosmosbay.com>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>	<43C247CF.2000608@cosmosbay.com>
	<43DA393F.6010801@cosmosbay.com>	<20060127073721.1888808f@localhost.localdomain>	<43DA403D.8090405@cosmosbay.com>
	<20060127095300.57fdd7e7@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20060127095300.57fdd7e7@localhost.localdomain>
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

Stephen Hemminger a =C3=A9crit :
> On Fri, 27 Jan 2006 16:46:05 +0100
> Eric Dumazet <dada1@cosmosbay.com> wrote:
>=20
>> Stephen Hemminger a =C3=A9crit :
>>> On Fri, 27 Jan 2006 16:16:15 +0100
>>> Eric Dumazet <dada1@cosmosbay.com> wrote:
>>>
>>>> This patch helps scalability of x_tables on SMP, especially NUMA mac=
hines.
>>>>
>>>> Instead of using a single rwlock_t to protect x_tables, use an array=
 of=20
>>>> rwlock_t, one for each possible cpu in the machine.
>=20
> It makes no sense to have a per-cpu lock. Why not just use per-cpu coun=
ters
> and bh_disable()?
>=20

If you examin the x_tables code, you'll discover :

A CPU A might enters the code (ipt_do_table()) because a packet is proces=
sed :=20
it follows the rules, increment 64 bits packet counts and 64 bits bytes=20
counters of matched rules... Then it leaves the code.
For this stage a read_lock_bh() was used to let this cpu does its job=20
(including recursive calls apparently)

Then a CPU B wants to either :

[1] - replace the rules by a new set, atomically keeping all counters val=
ues
    (example : iptables -A INPUT -p tcp)
[2] - Read all the rules and associated counters atomically.
     (example : iptables -nvL INPUT)
[...] - Other interesting things like resetting al counters
     (example : iptables -Z)
This kind of task uses a write_lock_bh() to be sure CPU A will block in=20
read_lock_bh()

Then a CPU C wants to to a task similar to B (imagine you have a periodic=
=20
fetch of counters to feed a RRD database) : you want that CPU C doesnt re=
ad=20
garbage values when CPU B adds a new rule in a chain, and while CPU A fee=
d=20
more network packets...


You need some kind of exclusion so that CPU B reads sane values, not valu=
es=20
currently modified by CPU A. You need some kind of exclusion to let CPU B=
=20
doing some table exchange (and keeps counters).

counters are already 'per-cpu' (ie each CPU only reads its own copy of ru=
les=20
and change its own counters), and bh_disable() wont permit exclusion betw=
een CPUS.

And finally you want to keep compatibility with user programs and existin=
g API...

So using a per-cpu rwlock does make sense...

Eric
