From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Fw: 2.6.15-rc2-mm1 problems (get_cpu / NUMA optimizations)
Date: Thu, 24 Nov 2005 23:11:31 +0100
Message-ID: <43863A93.2010406@cosmosbay.com>
References: <20051123.155603.64967447.davem@davemloft.net>
	<20051124205828.GD31478@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051124205828.GD31478@sunbeam.de.gnumonks.org>
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
> On Wed, Nov 23, 2005 at 03:56:03PM -0800, David S. Miller wrote:
>=20
>>I've seen this reported multiple times.
>>
>>It seems that module load is attempted by IP-tables while
>>some locks are held, or similar.
>=20
>=20
> yes, this was introduced by the recent NUMA patches that introduced
> get_cpu() / put_cpu() all over the place. =20
>=20
>

Hum... I was not aware that disabling preemption (in get_cpu()) had this=20
effect (ie not allowing to sleep). I was using get_cpu() to bind the thre=
ad to=20
the current cpu, maybe there is something better ?

If not, we can zap get_cpu()/pu_cpu() and use raw_smp_processor_id() as a=
 hint=20
only, (and dont care of preemption/cpu migration), as the value is only u=
sed=20
as a hint to speedup operations in do_replace(), do_add_counters(),=20
ipt_unregister_table(), translate_table()...

Eric
