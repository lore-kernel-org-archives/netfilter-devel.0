From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: xt_connlimit 20070605
Date: Tue, 5 Jun 2007 14:37:42 +0200
Message-ID: <20070605143742.7fdd6268.dada1@cosmosbay.com>
References: <Pine.LNX.4.61.0706051315400.20829@yvahk01.tjqt.qr>
	<46654BF8.30406@trash.net>
	<Pine.LNX.4.61.0706051405510.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051405510.20829@yvahk01.tjqt.qr>
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

On Tue, 5 Jun 2007 14:06:50 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

>
> +static inline unsigned int connlimit_iphash(u_int32_t addr)
> +{
> +	return (addr ^ (addr >> 8) ^ (addr >> 16) ^ (addr >> 24)) & 0xff;
> +}
> +
> +static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
> +		      u_int32_t mask, struct nf_conn *ct)

There is some problem with this hash function :

An attacker can easily send on your machine SYN packets where addr 
is carefully chosen so that your hash function returns the same value.

Time to scan 1.000 elements in a chain is too long.

I suggest you use jhash and a random value (initialized at boot time), so that
the attacker has hard work to guess your hash function.

See for examples :

 net/ipv4/route.c , function rt_hash_code()

 net/netfilter/nf_conntrack_core.c , function __hash_conntrack()

 net/ipv4/netfilter/ipt_recent.c, function recent_entry_hash()
