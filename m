From: Patrick McHardy <kaber@trash.net>
Subject: Re: nfhook, sk_buff and change data
Date: Sun, 12 Mar 2006 15:46:03 +0100
Message-ID: <4414342B.2060709@trash.net>
References: <Pine.A41.4.58.0603121634310.753742@beluga.user.services.metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: nebi senol yilmaz <nsyilmaz@metu.edu.tr>
In-Reply-To: <Pine.A41.4.58.0603121634310.753742@beluga.user.services.metu.edu.tr>
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

nebi senol yilmaz wrote:
> hello;
> 
> i've a problem about sk_buff checksum (tcp checksum).
> 
> I've coded a kernel module that makes some changes at some packets ,
> which are read at NF_IP_FORWARD hook.
> My module changes data of the packetand returns  NF_ACCEPT...
> 
> but the packet with changed data can not be accepted by the target
> machine.
> 
> i'm calculating both ip header checksum and tcp checksum, but still
> i've problem..
> 
> does anybody know about my problem? can you give me some advice
> whether you have  any solutions about it.
> 
> 
> related piece of code is below:
> 
> 
> ===================
> unsigned int hook_pool(unsigned int hooknum,
>                                struct sk_buff **skb,
>                                const struct net_device *in,
>                                const struct net_device *out,
>                                int (*okfn)(struct sk_buff*)){
> 
> 
> 
>        struct tcphdr *tcp;
>        char *data;
>        struct sk_buff *sock_buff;
>        int i=0;
>        char *findGzip;
> 
>        sock_buff=*skb;
> 
>        tcp = (struct tcphdr *)(sock_buff->data + (sock_buff->nh.iph->ihl * 4));
>        data = (char *)((int)tcp + (int)(tcp->doff * 4));
> 
> 
>        if (findGzip=(strstr(data,"senol1763"))){
>                printk("%d Data CheckSum 1 = %u\n",hooknum,sock_buff->csum);
>                printk("%d TCP CheckSum 1 = %u\n",hooknum,sock_buff->h.th->check);
>                printk("%d IP CheckSum 1 = %u\n",hooknum,sock_buff->nh.iph->check);
>                printk("\n");
> 
>                findGzip[1]='n'; /* when i find a related str, i change a char*/
> /* here, i'm calculating ne csum.*/
>                sock_buff->h.th->check=0;
> sock_buff->h.th->check=in_cksum_tcp(sock_buff->nh.iph->saddr,sock_buff->nh.iph->daddr,(unsigned short *)sock_buff->h.th , sizeof(*sock_buff->h.th) );

In the FORWARD hook skb->h.th doesn't point to the TCP header.
