From: qber66 <tim.vandermeersch@pandora.be>
Subject: Problems determining the correct tcp header size
Date: Wed, 19 Mar 2003 20:04:47 +0000 (UTC)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E809133.4050400@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
Date: Tue, 25 Mar 2003 18:26:11 +0100
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm making a new target for iptables, but I'n having a problems with 
determining the correct tcp header lenght in the following function:

static unsigned int ipt_mytarget_target(struct sk_buff **pskb, unsigned 
int hooknum,
        const struct net_device *in, const struct net_device *out,
        const void *targetinfo, void *userinfo)
{
    struct tcphdr *tcph = (struct tcphdr *) (*pskb)->h.th;
    struct iphdr *iph = (struct iphdr *) (*pskb)->nh.iph;

    printk(KERN_WARNING "iphdr lenght: %d, tcphdr lenght: %d\n", 
iph->ihl*4, tcph->doff*4);
}


When I use this rule:

iptables -t mangle -A POSTROUTING -p TCP -j MYTARGET

I get the following output:

iphdr lenght: 20, tcphdr lenght: 0
iphdr lenght: 20, tcphdr lenght: 0
iphdr lenght: 20, tcphdr lenght: 16
iphdr lenght: 20, tcphdr lenght: 0
iphdr lenght: 20, tcphdr lenght: 4
iphdr lenght: 20, tcphdr lenght: 16
iphdr lenght: 20, tcphdr lenght: 16
iphdr lenght: 20, tcphdr lenght: 0
iphdr lenght: 20, tcphdr lenght: 0
iphdr lenght: 20, tcphdr lenght: 4
iphdr lenght: 20, tcphdr lenght: 0
iphdr lenght: 20, tcphdr lenght: 16
iphdr lenght: 20, tcphdr lenght: 4
iphdr lenght: 20, tcphdr lenght: 0
.....

Can any one tell me what I'm doing wrong?

Thanks in advance,
Tim Vandermeersch.
