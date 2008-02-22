From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: SAME removal and NAT IP selection
Date: Fri, 22 Feb 2008 17:19:03 +0100
Message-ID: <47BEF5F7.5010701@trash.net>
References: <47BD7187.7000403@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040501060409060706000400"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:54758 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754169AbYBVQTI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:19:08 -0500
Received: from [192.168.0.100] (really [78.42.105.25])
          by viefep19-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080222161904.OATO2163.viefep19-int.chello.at@[192.168.0.100]>
          for <netfilter-devel@vger.kernel.org>;
          Fri, 22 Feb 2008 17:19:04 +0100
In-Reply-To: <47BD7187.7000403@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040501060409060706000400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> As soon as we've removed the SAME target, I got some complaints
> from users that not only need persistent IPs when talking to the
> same destination, but for all destinations, which NAT currently
> doesn't provide.
> 
> I don't want to resurrect the SAME target because of the 32/64bit
> compat problems it had, it would be better to handle this in the
> NAT core. The IP is currently determined by hashing the source and
> destinations IPs and mapping the hash to the NAT range:
> 
>         minip = ntohl(range->min_ip);
>         maxip = ntohl(range->max_ip);
>         j = jhash_2words((__force u32)tuple->src.u3.ip,
>                          (__force u32)tuple->dst.u3.ip, 0);
>         j = ((u64)j * (maxip - minip + 1)) >> 32;
>         *var_ipp = htonl(minip + j);
> 
> We have two options:
> 
> - add a flag to the NAT range to ignore the destination
>   IP for SNAT
> 
> - always ignore the destination IP for SNAT
> 
> I personally prefer the second option since it results in more
> consistency and avoids adding new a option. I'm can't think
> of a reason why we would need to include the destination for
> SNAT, using jhash should result in good distribution anyway,
> but I might be missing something.
> 
> Any opinions?


I've queued this patch implementing the second option.
I'll push it for 2.6.25 since from a user-perspective this
constitutes a regression, even though it was announced for
quite some time.



--------------040501060409060706000400
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit c8fe51f524b3098adff20bb79105bb6dfe4db8a4
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Feb 22 17:16:08 2008 +0100

    [NETFILTER]: nf_nat: always select same SNAT source for same host
    
    We've removed the SAME target in 2.6.25-rc since it had 32/64 bit compat
    problems and the NAT core provides the same behaviour regarding IP
    selection. This turned out to be not entirely correct though, the
    NAT core only selects the same IP from a range for the same src,dst
    combination. Some people need the same IP for all destinations however.
    
    The easiest way to do this is to ignore the destination IP when
    doing SNAT. Since we're using jhash, we still get good distribution
    for multiple source IPs.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 0d5fa3a..8e1cae2 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -188,15 +188,19 @@ find_best_ips_proto(struct nf_conntrack_tuple *tuple,
 	__be32 *var_ipp;
 	/* Host order */
 	u_int32_t minip, maxip, j;
+	__be32 dst;
 
 	/* No IP mapping?  Do nothing. */
 	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
 		return;
 
-	if (maniptype == IP_NAT_MANIP_SRC)
+	if (maniptype == IP_NAT_MANIP_SRC) {
 		var_ipp = &tuple->src.u3.ip;
-	else
+		dst = 0;
+	} else {
 		var_ipp = &tuple->dst.u3.ip;
+		dst = tuple->dst.u3.ip;
+	}
 
 	/* Fast path: only one choice. */
 	if (range->min_ip == range->max_ip) {
@@ -212,8 +216,7 @@ find_best_ips_proto(struct nf_conntrack_tuple *tuple,
 	 * like this), even across reboots. */
 	minip = ntohl(range->min_ip);
 	maxip = ntohl(range->max_ip);
-	j = jhash_2words((__force u32)tuple->src.u3.ip,
-			 (__force u32)tuple->dst.u3.ip, 0);
+	j = jhash_2words((__force u32)tuple->src.u3.ip, (__force u32)dst, 0);
 	j = ((u64)j * (maxip - minip + 1)) >> 32;
 	*var_ipp = htonl(minip + j);
 }

--------------040501060409060706000400--
