From: Pablo Neira <pablo@eurodev.net>
Subject: [RFC] Event Cache per-cpu
Date: Mon, 08 Nov 2004 20:29:38 +0100
Message-ID: <418FC922.9080004@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi all,

I've been discussing this issue with Patrick during last week. I've 
found two problems with the current approach of a event cache per cpu. 
The problem is related to 1) preemption, 2) the fact that 
ip_conntrack_in can be called from process and softirq context.

1) If preemption is enable, a calling process walking on ip_conntrack_in 
could be preempted by other process which has more priority on the same CPU.

2) A calling process walking on ip_conntrack can be preempted by a 
softirq which could walk the same piece of bits on the same CPU.

In both cases, the event cache will be corrupted. In resume, I see three 
possibilities:

a) per-cpu event cache. Won't work, even if we disable preemption in 
ip_conntrack_in, we can still have problems with softirqs preempting a 
calling process.

b) per conntrack cache. It won't work, in a SMP environment, two packets 
of the same connection can be handled by two different CPU's.

c) per packet cache. I don't see any possible race with this approach at 
the moment, but I'll need to use the nfcache field in skbuff. I prefer 
this than adding a new field to a skbuff, I think that Davem won't like 
that.

There's 15 bits in nfcache available now (because IPVS guys are using 
one in private). My last patch has 11 events.

enum ip_conntrack_events
{
       IPCT_NEW,                       /* New conntrack                */
       IPCT_RELATED,                   /* Expected connection          */
       IPCT_DESTROY,                   /* Destroyed conntrack          */
       IPCT_STATUS,                    /* Status has changed           */
       IPCT_REFRESH,                   /* Timer has been refreshed     */
       IPCT_PROTOINFO,                 /* Update of protocol info      */
       IPCT_PROTOINFO_VOLATILE,        /* Volatile protocol info       */
       IPCT_HELPER,                    /* New helper for conntrack     */
       IPCT_HELPINFO,                  /* Update of helper info        */
       IPCT_HELPINFO_VOLATILE,         /* Volatile helper info         */
       IPCT_NATINFO,                   /* NAT info                     */
};

Patrick suggests that we could run out of bits soon if events go in 
nfcache, that's true. To fix that, could we remove this stuff in 
netfilter_ipv4.h, nobody is using it ?

#define NFC_IP_SRC              0x0001
/* Dest IP address. */
#define NFC_IP_DST              0x0002
...

Please, comments welcome.

Pablo
