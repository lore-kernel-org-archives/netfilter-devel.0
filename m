From: Tim Vandermeersch <tim.vandermeersch@pandora.be>
Subject: Re: Problems determining the correct tcp header size
Date: Fri, 28 Mar 2003 00:19:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8386EE.6040701@pandora.be>
References: <3E809133.4050400@pandora.be> <20030326153502.GB21953@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>On Tue, Mar 25, 2003 at 06:26:11PM +0100, qber66 wrote:
>  
>
>>Hi,
>>
>>I'm making a new target for iptables, but I'n having a problems with 
>>determining the correct tcp header lenght in the following function:
>>
>>static unsigned int ipt_mytarget_target(struct sk_buff **pskb, unsigned 
>>int hooknum,
>>       const struct net_device *in, const struct net_device *out,
>>       const void *targetinfo, void *userinfo)
>>{
>>   struct tcphdr *tcph = (struct tcphdr *) (*pskb)->h.th;
>>    
>>
>
>you cannot blindly assume that all packets are tcp.
>
>  
>
>>I get the following output:
>>
>>iphdr lenght: 20, tcphdr lenght: 0
>>iphdr lenght: 20, tcphdr lenght: 16
>>iphdr lenght: 20, tcphdr lenght: 4
>>    
>>
>
>  
>
>>Can any one tell me what I'm doing wrong?
>>    
>>
>
>maybe it's non-tcp packets?
>
>  
>
>>Thanks in advance,
>>Tim Vandermeersch.
>>    
>>
>
>  
>
Hi,

At the moment I'm using '-p TCP' to make sure that all packets are TCP, 
the final version will look at the protocol in the iphdr.

With the following function you can compare the tcp header lenght from 
the (*pskb)->h.th with the one calculated using (*pskb)->data[some_math..]

static unsigned int ipt_mytarget_target(struct sk_buff **pskb, unsigned 
int hooknum,
	const struct net_device *in, const struct net_device *out,
	const void *targetinfo, void *userinfo)
{
	struct iphdr *iph = (struct iphdr *) (*pskb)->nh.iph;
	struct tcphdr *tcph = (struct tcphdr *) (*pskb)->h.th;
        int i;

        printk("tcp_len = %d, tcp_len = %d\n", ((*pskb)->data[iph->ihl*4+12]>>4)*4, tcph->doff*4);
        for (i=0; i<40; i++) {
             printk("%2.2X ", (char *) (*pskb)->data[i]);
        }
        printk("\n\n");		
        
        return IPT_CONTINUE;
}

This produces the following output:

tcp_len = 32, tcp_len = 52
45 00 00 34 19 D8 40 00 32 06 73 C5 D9 11 21 0A C0 A8 00 63 1A 0B 0C 29 7E 44 0B 5F B9 54 D1 59 80 10 81 FA AF DC 00 00 
tcp_len = 32, tcp_len = 52
45 00 00 61 55 FC 40 00 32 06 37 74 D9 11 21 0A C0 A8 00 63 1A 0B 0C 29 7E 44 0B 5F B9 54 D1 59 80 18 82 18 60 97 00 00 
tcp_len = 32, tcp_len = 48
45 00 00 34 2C 24 40 00 3F 06 54 79 C0 A8 00 63 D9 11 21 0A 0C 29 1A 0B B9 54 D1 59 7E 44 0B 8C 80 10 87 C0 A9 C9 00 00 
...

32 is the correct size, but why do i get 52, 48, ... from tcph->doff*4 ?

I allready downloaded the kernel source (from linux.org) and compiled a new kernel again. Does any one know what might be causing these incorrect header sizes?


Thanks in advance,
Tim Vandermeersch
