From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Iptables multiport match fix
Date: Wed, 10 Jul 2002 10:38:33 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020710083833.GL23676@naboo.de.gnumonks.org>
References: <veznx0ejov.fsf@inigo.ingate.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <veznx0ejov.fsf@inigo.ingate.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 09, 2002 at 10:21:36PM +0200, Marcus Sundberg wrote:
> Hi,
> 
> The multiport match checks for the IPT_INV_PROTO flag in the 'flags'
> member of struct ipt_ip instead of in the 'invflags' member.

thanks for this fix.
> 
> diff -ur linux.current/net/ipv4/netfilter/ipt_multiport.c linux-mine/net/ipv4/netfilter/ipt_multiport.c
> --- linux-2.4.19-rc1/net/ipv4/netfilter/ipt_multiport.c	Tue Jun 20 23:32:27 2000
> +++ linux/net/ipv4/netfilter/ipt_multiport.c	Tue Jul  9 10:43:23 2002
> @@ -78,7 +78,7 @@
>  
>  	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
>  	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
> -		&& !(ip->flags & IPT_INV_PROTO)
> +		&& !(ip->invflags & IPT_INV_PROTO)
>  		&& matchsize == IPT_ALIGN(sizeof(struct ipt_multiport))
>  		&& (multiinfo->flags == IPT_MULTIPORT_SOURCE
>  		    || multiinfo->flags == IPT_MULTIPORT_DESTINATION
> 
> (Where should I send this btw? The kernel part of iptables doesn't
> seem to be in the netfilter CVS. Was I supposed to create a p-o-m
> patch? Or send it directly to Marcelo?)

send it to the netfilter development list
(netfilter-devel@lists.samba.org). The netfilter developers will then 
check/test and submit to DaveM for kernel inclusion.

> //Marcus

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
