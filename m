From: John Lange <john.lange@open-it.ca>
Subject: Re: iptables --log-uid patch for 2.6
Date: Wed, 08 Dec 2004 00:10:59 -0600
Message-ID: <1102486259.2214.2276.camel@ws102.darkcore.net>
References: <1101668109.2922.1618.camel@ws102.darkcore.net>
	<41B6840C.1030706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41B6840C.1030706@trash.net>
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

Thanks for response Patrick.

One small note... 

I believe there is a limitation to this approach that makes it tricky
for blocking outbound packets. I hope you have a work-around.

Specifically, there is no way to allow packets that have no UID set such
as packets generated directly by the kernel.

The following rules were designed to block users from (accidentally)
installing spam relays on their web accounts (bad CGI scripts for
example).

I hope this example makes some sense:

e.g.

# first allow root (this allows root, but NOT the kernel!)
iptables -A OUTPUT -p ALL -m owner --uid-owner 0 -j ACCEPT

# allow anyone in the mail group
iptables -A OUTPUT -p tcp -m owner --gid-owner 102 --dport 25 -j ACCEPT

iptables -A OUTPUT -p tcp --dport 25 -j LOG --log-uid
iptables -A OUTPUT -p tcp --dport 25 -j DROP

----

Packets generated directly by the kernel (like RST packets) have no UID
set and therefore get blocked....

I suppose you could allow based on the type of packet but its not
exactly what you expect.

-- 
John Lange
OpenIT ltd.
(204) 885 0872

On Tue, 2004-12-07 at 22:33, Patrick McHardy wrote:
> John Lange wrote:
> 
> >I sent this to the list yesterday but I don't think it made it through.
> >Apologies if it is a duplicate.
> >
> >Here are patches against the userspace and the kernel which allows the
> >logging of the uid that generated the (outgoing) packet.
> >
> >This patch was originally the work of Martin Josefsson for the 2.4
> >kernel but was never incorporated into the main code base. My work here
> >simply ports it to the 2.6 kernel and the current version of netfilter
> >(iptables).
> >
> Thanks, I've fixed locking (packets with skb->sk set may reach ipt_LOG
> without the socket lock held through tunnel devices, so we need extra
> locking) and added this patch to my tree. I'm going to add the userspace
> patch when SVN is up again.
> 
> Regards
> Patrick
> 
> 
> ______________________________________________________________________
> # This is a BitKeeper generated diff -Nru style patch.
> #
> # ChangeSet
> #   2004/12/08 04:53:15+01:00 kaber@coreworks.de 
> #   [NETFILTER]: Add --log-uid option to ipt_LOG
> #   
> #   Signed-off-by: Patrick McHardy <kaber@trash.net>
> # 
> # net/ipv4/netfilter/ipt_LOG.c
> #   2004/12/08 04:53:08+01:00 kaber@coreworks.de +8 -0
> #   [NETFILTER]: Add --log-uid option to ipt_LOG
> #   
> #   Signed-off-by: Patrick McHardy <kaber@trash.net>
> # 
> # include/linux/netfilter_ipv4/ipt_LOG.h
> #   2004/12/08 04:53:08+01:00 kaber@coreworks.de +2 -1
> #   [NETFILTER]: Add --log-uid option to ipt_LOG
> #   
> #   Signed-off-by: Patrick McHardy <kaber@trash.net>
> # 
> diff -Nru a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
> --- a/include/linux/netfilter_ipv4/ipt_LOG.h	2004-12-08 05:26:20 +01:00
> +++ b/include/linux/netfilter_ipv4/ipt_LOG.h	2004-12-08 05:26:20 +01:00
> @@ -4,7 +4,8 @@
>  #define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
>  #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
>  #define IPT_LOG_IPOPT		0x04	/* Log IP options */
> -#define IPT_LOG_MASK		0x07
> +#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
> +#define IPT_LOG_MASK		0x0f
>  
>  struct ipt_log_info {
>  	unsigned char level;
> diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
> --- a/net/ipv4/netfilter/ipt_LOG.c	2004-12-08 05:26:20 +01:00
> +++ b/net/ipv4/netfilter/ipt_LOG.c	2004-12-08 05:26:20 +01:00
> @@ -327,6 +327,14 @@
>  		printk("PROTO=%u ", ih->protocol);
>  	}
>  
> +	/* Max length: 15 "UID=4294967295 " */
> + 	if ((info->logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
> +		read_lock_bh(&skb->sk->sk_callback_lock);
> +		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
> + 			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
> +		read_unlock_bh(&skb->sk->sk_callback_lock);
> +	}
> +
>  	/* Proto    Max log string length */
>  	/* IP:      40+46+6+11+127 = 230 */
>  	/* TCP:     10+max(25,20+30+13+9+32+11+127) = 252 */
