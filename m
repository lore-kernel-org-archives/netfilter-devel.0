From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Thu, 13 Oct 2005 18:46:06 +1000
Message-ID: <E1EPyj0-0001dx-00@gondolin.me.apana.org.au>
References: <20051012.155419.36023860.davem@davemloft.net>
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	bdschuym@pandora.be, seb@frankengul.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net (David S. Miller)
In-Reply-To: <20051012.155419.36023860.davem@davemloft.net>
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

David S. Miller <davem@davemloft.net> wrote:
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index b15826f..36c46a7 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -392,4 +392,18 @@ extern cpumask_t cpu_present_map;
> #define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_map)
> #define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_map)
> 
> +/* Find the highest possible smp_processor_id() */
> +static inline unsigned int highest_possible_processor_id(void)
> +{
> +       unsigned int cpu, highest = 0;
> +
> +       for_each_cpu_mask(cpu, cpu_possible_map) {
> +               if (cpu > highest)
> +                       highest = cpu;
> +       }
> +
> +       return highest;
> +}

This is a cue for someone to do find_last_bit for 2.6.15 :)

In the mean time we can at least kill the (cpu > highest) check since
cpu is monotonically increasing.

> @@ -893,11 +895,8 @@ static void get_counters(struct ebt_coun
>        int i, cpu;
>        struct ebt_counter *counter_base;
> 
> -       /* counters of cpu 0 */
> -       memcpy(counters, oldcounters,
> -          sizeof(struct ebt_counter) * nentries);
>        /* add other counters to those of cpu 0 */
> -       for (cpu = 1; cpu < num_possible_cpus(); cpu++) {
> +       for_each_cpu(cpu) {
>                counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
>                for (i = 0; i < nentries; i++) {
>                        counters[i].pcnt += counter_base[i].pcnt;

I'm not sure about this.  Counters hasn't been zeroed yet, has it?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
