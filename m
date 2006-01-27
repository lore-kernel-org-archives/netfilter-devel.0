From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] x_tables : Use SMP friendly (percpu) rwlock_t to protect
 x_tables
Date: Fri, 27 Jan 2006 16:46:05 +0100
Message-ID: <43DA403D.8090405@cosmosbay.com>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>	<43C247CF.2000608@cosmosbay.com>
	<43DA393F.6010801@cosmosbay.com>
	<20060127073721.1888808f@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20060127073721.1888808f@localhost.localdomain>
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

Stephen Hemminger a =E9crit :
> On Fri, 27 Jan 2006 16:16:15 +0100
> Eric Dumazet <dada1@cosmosbay.com> wrote:
>=20
>> This patch helps scalability of x_tables on SMP, especially NUMA machi=
nes.
>>
>> Instead of using a single rwlock_t to protect x_tables, use an array o=
f=20
>> rwlock_t, one for each possible cpu in the machine.
>>
>> 1) No more cache line ping pongs between cpus. read_lock_bh(&table->lo=
ck) /=20
>> read_unlock_bh(&table->lock) were still expensive because of the very =
hot=20
>> central rwlock.
>>
>> 2) get_counters() is more latency friendly than before (we lock each s=
ub table=20
>> one at a time instead of the full x_tables)
>>
>> 3) When a replace of table must be done, the 'writer' have to write_lo=
ck_bh()=20
>> all the locks of the array. This is 'expensive' but seldom done (under=
lying=20
>> vmalloc/copy_from_user costs are more expensive anyway)
>>
>> This patch was tested on a 4 way Opteron machine, two gigabit links, w=
ith=20
>> rather complex iptables rules (around 200 rules) and gives excellent r=
esults=20
>> so far.
>>
>>
>> Thank you
>> Eric Dumazet
>>
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>>
>=20
> You just reinvented brlock.  Figure out how to use atomic operations an=
d/or RCU
> and you will do even better.
>=20
>=20

Thanks Stephen for this very constructive comment.

After RCU being added to ipv4 route cache (by RCU experts, not me), my ma=
in=20
servers cannot work anymore reliably.

If somebody can prove me RCU can works on x_tables, I'm open.

Eric
