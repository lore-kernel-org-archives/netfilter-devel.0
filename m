From: Amin Azez <azez@ufomechanic.net>
Subject: Re: no ctstat? Re: building libctnetlink
Date: Wed, 06 Apr 2005 17:30:28 +0100
Message-ID: <42540EA4.1000001@ufomechanic.net>
References: <423BF227.8030502@outerspace.dyndns.org>	<423BF4DC.2070902@outerspace.dyndns.org>	<1111335091.2523.46.camel@lap-ufomechanic>	<1111335425.2523.49.camel@lap-ufomechanic>	<423DF940.100@eurodev.net>	<1111412190.2716.55.camel@lap-ufomechanic>	<423F007F.2060102@eurodev.net>	<1111667756.2526.19.camel@lap-ufomechanic>	<4242B977.1030607@eurodev.net>	<d2rpmi$3n8$1@sea.gmane.org>
	<d30tcp$tsc$1@sea.gmane.org>	<d3107o$933$1@sea.gmane.org>
	<1112806753.2704.7.camel@lap-ufomechanic>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1112806753.2704.7.camel@lap-ufomechanic>
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

Just another UFO mechanic wrote:
> On Wed, 2005-04-06 at 16:48, Amin Azez wrote:
> 
>>as Soon as my linux 2.6.11.6 source downloaded I tried:
>>IPTABLES_DIR=../iptables-1.2.11/ KERNEL_DIR=../linux-2.6.11.6 ./runme 
>>--batch nfnetlink-ctnetlink-0.13
>>
>>But it just says:
>>
>>unable to find ladd slot in src 
>>../linux-2.6.11.6/include/linux/netfilter_ipv4/ip_conntrack.h 
>>(./nfnetlink-ctnetlink-0.13/li)-----------------------------------------------------------------
>>Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?]
>>
>>I dont know what a ladd slot is (OK, its a line-add slot, but I still 
>>don't know what it is) but I'll take this to mean the patch was for 2.6.10
>>
>>The rejected hunks have thinks like:
>>   #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
>>   struct notifier_block *ip_conntrack_chain;
>>   #endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
>>
>>in, which makes it look like ct-event is needed, perhaps such as pablo 
>>posted on 28/03/05 for kernel 2.6.11
>>
>>I'll take this up on the "[PATCH] ct-event API port to 2.6.11" thread.
> 
> 
>>Amin
> 
> 
> Amin nar nin buzee, as ta den feB. Av ni no bin 2.6.12 kez nip obou
> avayop armal nupiy wen karsanel.
> 
> CONFIG_IP_NF_CONNTRACK_EVENTS=y
> 
> Niki wen swe ning.

Sound as my lovely dad, you do.

On reflection, netfilter patches against specific kernels are likely to 
require it as a minimum version to patch against, I mean there is more 
likelyhood that a patch will patch against the next kernel revision than 
  the previous kernel revision, so yeah, it may mean a skip up to 
2.6.12, if that has ct-event in it

agghh!

thanks

Amin
