From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH] DECLARE_MUTEX in ip6_tables.h just like ip_tables.h
Date: Tue, 08 Feb 2005 16:51:39 -0500
Message-ID: <4209346B.5020100@cookinglinux.org>
References: <57143.142.169.215.10.1107791547.squirrel@142.169.215.10>	<4207FF25.1060404@cookinglinux.org>
	<42080504.2080606@eurodev.net>
	<Pine.LNX.4.62.0502080751120.32526@kaber.coreworks.de>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, jamal <hadi@cyberus.ca>,
	netfilter-devel@lists.netfilter.org,
	Pablo Neira <pablo@eurodev.net>, John Hill <jhill@noach.com>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.62.0502080751120.32526@kaber.coreworks.de>
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

Patrick McHardy wrote:
> On Tue, 8 Feb 2005, Pablo Neira wrote:
> 
>> Anyway, I didn't find any client of ipt_mutex. I think it's better if 
>> we move it to its original place, ip_tables.c.
> 
> 
> Agreed, we already got rid of this in 2.6. I've applied your patch,
> thanks.
> 
> Regards
> Patrick
> 

John Hill pointed out the same happens on libip6t* libraries compilation time.

Here's a patch like Pablo's ip_tables.h one.

Regards,
Samuel

Signed-off-by: Samuel Jean <sjean@cookinglinux.org>

diff -ur linux-2.4.29-bk8/include/linux/netfilter_ipv6/ip6_tables.h 
linux-2.4.29-bk8-patched/include/linux/netfilter_ipv6/ip6_tables.h
--- linux-2.4.29-bk8/include/linux/netfilter_ipv6/ip6_tables.h  2004-08-07 19:26:06.000000000 -0400
+++ linux-2.4.29-bk8-patched/include/linux/netfilter_ipv6/ip6_tables.h  2005-02-08 
16:37:40.000000000 -0500
@@ -106,8 +106,6 @@
         u_int64_t pcnt, bcnt;                   /* Packet and byte counters */
  };

-static DECLARE_MUTEX(ip6t_mutex);
-
  /* Values for "flag" field in struct ip6t_ip6 (general ip6 structure). */
  #define IP6T_F_PROTO           0x01    /* Set if rule cares about upper
                                            protocols */
diff -ur linux-2.4.29-bk8/net/ipv6/netfilter/ip6_tables.c 
linux-2.4.29-bk8-patched/net/ipv6/netfilter/ip6_tables.c
--- linux-2.4.29-bk8/net/ipv6/netfilter/ip6_tables.c    2005-01-19 09:10:14.000000000 -0500
+++ linux-2.4.29-bk8-patched/net/ipv6/netfilter/ip6_tables.c    2005-02-08 16:38:35.000000000 -0500
@@ -58,6 +58,7 @@
  #endif
  #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))

+static DECLARE_MUTEX(ip6t_mutex);

  /* Must have mutex */
  #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ip6t_mutex) != 0)
