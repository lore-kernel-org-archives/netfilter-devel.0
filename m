From: Valery Voevudsky <vvoevudsky@borderware.com>
Subject: User netfilter's kernel module hook that does NAPT in Linux 2.6.
Date: Mon, 28 Aug 2006 17:11:37 -0400
Message-ID: <1156799497.5984.38.camel@vvoevudsky-desktop>
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

Hello all:

I have the following challenge that I do not know how to overcome.

I am porting a kernel module from FreeBSD to Linux 2.6 using the
netfilter paradigm.

Actually it is a kernel module with the NF_IP_PRE_ROUTING hook that does
NAPTing on its own: replaces source and destination addresses and ports,
recalculates checksums and returns NF_ACCEPT. A have attached the source
code below. 

The ethereal shows that the checksums for the IP/UDP headers are correct
so I would expect that the corrected packet with the new destination
IP:port will be sent accordingly by the netfilter. But actually the
packet does not leave my box (the post-routing hook shows that).
 

In the log I see something like this:
  
martian source 10.1.35.110 from 10.1.253.143, on dev eth1
ll header: 00:0a:5e:53:7a:8d:00:0e:08:da:f2:da:08:00


I need your help guys. Actually I need a working tutorial and source
example that does the real NAT/NAPT. Most of tutorial that I've read are
related to Linux 2.4. The documentation for 2.6 is not verbose as I
would expect.  

Thanks in advance,
       Valery Voevudsky
 

===========================================================================
This is my version of linux:

~$ uname -a
Linux vvoevudsky-desktop 2.6.15.7-ubuntu1 #2 SMP PREEMPT Mon Aug 28
12:52:32 EDT 2006 i686 GNU/Linux


============================================================================
This is the simplified source code of my module: 

int rtp_firewall_init(void)
{
    int ret = -1;
                        
    pre_netfilter_ops.hook       =       pre_firewall_hook;
    pre_netfilter_ops.owner      =       THIS_MODULE,
    pre_netfilter_ops.pf         =       PF_INET;
    pre_netfilter_ops.hooknum    =       NF_IP_PRE_ROUTING; 
    pre_netfilter_ops.priority   =       NF_IP_PRI_FIRST;  

    ret = nf_register_hook(&pre_netfilter_ops);    
}


unsigned int pre_firewall_hook(unsigned int hooknum,  
                  struct sk_buff **skb,
                  const struct net_device *in,
                  const struct net_device *out,
                  int (*okfn)(struct sk_buff*))
{
    int ret = -1;
    struct udphdr  * udph = NULL;     
    struct iphdr   * iph  = NULL;
    
    sock_buff = *skb;
    iph = sock_buff->nh.iph;

    udph = (struct udphdr *) 
           (sock_buff->data + (sock_buff->nh.iph->ihl *4)); 

    if(iph->protocol != IPPROTO_UDP)
    { 
        return NF_ACCEPT; 
    }
                 
    // So this is the UDP protocol

    // NAPTing: 
    iph->saddr  = 'new source IP-address';
    iph->daddr  = 'new destination IP-address';
    udph->source = 'new source port';
    udph->dest  = 'new destination port';

    // Re-calculate the checksum for ip header
    if (iph->check) 
    {
        iph->check = 0; // required by ip_fast_csum()!
        iph->check = ip_fast_csum((unsigned char *)iph,iph->ihl);
    }
    
    // Re-calculate the checksum for udp header
    if (udph->check != 0) 
    {
        udph->check = 'some checksum routine';
    }

    return NF_ACCEPT;
} // pre_firewall_hook
