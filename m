From: Krishna <krishna@eion.com>
Subject: Query on IPIP Encpasulation
Date: Sat, 13 Nov 2004 22:18:43 -0500
Message-ID: <1100402323.2519.11.camel@localhost.localdomain>
Reply-To: Krishna@eion.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I am very new to Kernel Module Programming. I need to capture packets
and perform a basic IP in IP encapsulation(i.e. I dont need to use
ipip.h). Hence I create a IP packet header and change the skb-> nh.iph
and add the existent IP header to skb->h.ipiph. I presume this is for
encapsulation. If I am wrong with this assumption, What does
skb->h.ipiph in the transport layer header do ? Please advise. I am able
to compile and I have a kernel module. But on loading, I am having
segmentation faults although I am not modifying. I also understand there
is another method whereby I allocate more headroom using skb_push..??

Please advise me. Pardon me for errors or some wrong assumption in the
code since I am still on the learning curve.

TIA,

Krish

Code segment-

static struct iphdr * ipgen, *temp;

unsigned int hook_func(unsigned int hooknum, struct sk_buff**skb, const
struct net_device *in, const struct net_device *out, int (*okfn)(struct
sk_buff*))
{
        /---- Criterion for selection----/  

   struct sk_buff *sb1=*skb;
   /* Build the IP header for the outer IP packet*/
   // struct iphdr *ipgen, *temp;  /*Template*/
   ipgen->tot_len = htons(sizeof(struct iphdr) +
sb1->nh.iph->tot_len);/*Total Length of the IP packet inclusive of the
encpasulated payload*/
   ipgen->ihl = 5; /* IP Header length*/
   ipgen->version = 4;/*Version of IP*/
   ipgen->ttl = 255; /* Hop Limit */
   ipgen->tos = sb1->nh.iph->tos; /* Copy the TOS from the incoming
packet*/
   ipgen->frag_off = sb1->nh.iph->frag_off; /* Fragmentation Offset
needs to be reflected*/
   ipgen->protocol = IPPROTO_IP;
   ipgen->saddr = sb1->nh.iph->saddr;
   ipgen->daddr = *(unsigned int *)dest_addr;
   ip_send_check(ipgen);
   /* As of now, sk_buff's pointer to iphdr has to be updated to ipip
header and ip header has to be repointed to Transport layer header*/
   //temp=sb1->nh.iph;
   sb1->nh.iph=ipgen;
   //sb1->h.ipiph=temp;
   #if 0
   sb1->csum = 0;
   csum = csum_partial(sb1->h.raw + doff, size - doff, 0);
   sb1->csum = csum; /* data checksum */
   #endif
   return NF_ACCEPT;
}
