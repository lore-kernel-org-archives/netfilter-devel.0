From: nebi senol yilmaz <nsyilmaz@metu.edu.tr>
Subject: Re: nfhook, sk_buff and change data
Date: Sun, 12 Mar 2006 16:59:26 +0200 (WET)
Message-ID: <Pine.A41.4.58.0603121654100.753746@beluga.user.services.metu.edu.tr>
References: <Pine.A41.4.58.0603121634310.753742@beluga.user.services.metu.edu.tr>
	<4414342B.2060709@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4414342B.2060709@trash.net>
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






> >
> >        tcp = (struct tcphdr *)(sock_buff->data + (sock_buff->nh.iph->ihl * 4));
> >        data = (char *)((int)tcp + (int)(tcp->doff * 4));
> >
> >
> >        if (findGzip=(strstr(data,"senol1763"))){
> >                printk("%d Data CheckSum 1 = %u\n",hooknum,sock_buff->csum);
> >                printk("%d TCP CheckSum 1 = %u\n",hooknum,sock_buff->h.th->check);
> >                printk("%d IP CheckSum 1 = %u\n",hooknum,sock_buff->nh.iph->check);
> >                printk("\n");
> >
> >                findGzip[1]='n'; /* when i find a related str, i change a char*/
> > /* here, i'm calculating ne csum.*/
> >                sock_buff->h.th->check=0;
> > sock_buff->h.th->check=in_cksum_tcp(sock_buff->nh.iph->saddr,sock_buff->nh.iph->daddr,(unsigned short *)sock_buff->h.th , sizeof(*sock_buff->h.th) );
>
> In the FORWARD hook skb->h.th doesn't point to the TCP header.
>




really?

now i wonder, how can i address the TCP header, and set the calculated
csum to header for each hook (if the pointer changes for each hook)?

But i've  never come up with this result when i'm googling and coding.

thanks for interest
