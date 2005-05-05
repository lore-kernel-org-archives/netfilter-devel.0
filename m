From: Pablo Neira <pablo@eurodev.net>
Subject: Re: BUG/CONFLICT conntrack with preroute/postroute mangle table
Date: Thu, 05 May 2005 18:05:43 +0200
Message-ID: <427A4457.7010509@eurodev.net>
References: <42677180.60003@ufomechanic.net>	<42677732.1000905@ufomechanic.net>	<20050421180723.03CF.LARK@linux.net.cn>	<426788B0.4090908@eurodev.net>	<426CF5FC.6090409@ufomechanic.net>	<426D1C69.2060107@ufomechanic.net>	<426D1E35.4030605@ufomechanic.net>	<426E4442.5070800@ufomechanic.net>
	<d5cue9$3qf$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, 'Krisztian Kovacs' <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <d5cue9$3qf$1@sea.gmane.org>
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

Amin Azez wrote:
> Further to the problem below, skb->nfcache is having the lower 2 bits 
> clobbered by net/ipv4/netfilter/ip_tables.c around line 316 (2.6.11.7)
> 
>         back = get_entry(table_base, table->private->underflow[hook]);
> 
>         do {
>                 IP_NF_ASSERT(e);
>                 IP_NF_ASSERT(back);
> 
> //THIS IS THE CULPRIT!
>                 (*pskb)->nfcache |= e->nfcache;
> 
> 
> e->nfcache has been observed at 0,1,2,0x4000
> 1 and 2 are IPCT_NEW and IPCT_RELATED and these are causing the damage.

This bug can be reproduced if you use iptables < 1.3.1, since I 
personally sent a patch to remove any nfcache references in iptables code.

https://lists.netfilter.org/pipermail/netfilter-devel/2005-February/018463.html

Yes, It's a matter of removing that line. thanks for pointing out this.

Krisztian, I think that this could be source of weird behaviours in 
ct_sync if your users use old iptables versions.

--
Pablo
