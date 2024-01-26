Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CE81CF90
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2024 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706284646; cv=none; b=aHIQs30K35sSqOLZ2c5d9fPyDwR10CvKiSniUJCuspwdOAW6imKq1mWgq+UjmgZR/ykgUjsRtXRkgrpKI5uQb46x/zA2zKOtfmDH9RcRL51oHqaUDLyMdkcku6oBVfP2MpRuyO16kPO59QU07JD0TBPTFpR/6xGV5XACJeDRCaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706284646; c=relaxed/simple;
	bh=11yKdOJ+IBLsGQECZ3/HrZbtlyADGaZo7j7cYlA2vvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A00wi0pQ0ZyHCPrvU6Mv+85M4+y4hqwLmqd/OSZB/Q7SD7nt7KOcQj7hOBxBQfXhKPgvnA3Z9PFNhwjeGn1ZpKNyAC1ItMc7SQV5nYGwHCaxT+s7vI2Pe3HMB8z4MjMlyxJPYzW/SDmIkq9FFkK69Kmr6a9bOfJdJrpPn6rMhu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rTOa0-0008Cs-U5; Fri, 26 Jan 2024 16:57:20 +0100
Date: Fri, 26 Jan 2024 16:57:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Kyle Swenson <kyle.swenson@est.tech>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] netfilter: nat: restore default DNAT behavior
Message-ID: <20240126155720.GD29056@breakpoint.cc>
References: <20240126000504.3220506-1-kyle.swenson@est.tech>
 <20240126000504.3220506-2-kyle.swenson@est.tech>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126000504.3220506-2-kyle.swenson@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)

Kyle Swenson <kyle.swenson@est.tech> wrote:
> When a DNAT rule is configured via iptables with different port ranges,
> 
> iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:32010
> -j DNAT --to-destination 192.168.0.10:21000-21010
> 
> we seem to be DNATing to some random port on the LAN side. While this is
> expected if --random is passed to the iptables command, it is not
> expected without passing --random.  The expected behavior (and the
> observed behavior in v4.4) is the traffic will be DNAT'd to
> 192.168.0.10:21000 unless there is a tuple collision with that
> destination.  In that case, we expect the traffic to be instead DNAT'd
> to 192.168.0.10:21001, so on so forth until the end of the range.
> 
> This patch is a naive attempt to restore the behavior seen in v4.4.  I'm
> hopeful folks will point out problems and regressions this could cause
> elsewhere, since I've little experience in the net tree.
> 
> Signed-off-by: Kyle Swenson <kyle.swenson@est.tech>
> ---
>  net/netfilter/nf_nat_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index c3d7ecbc777c..bd275c3906f7 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -549,12 +549,14 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
>  	}
>  
>  find_free_id:
>  	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
>  		off = (ntohs(*keyptr) - ntohs(range->base_proto.all));
> -	else
> +	else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
>  		off = get_random_u16();
> +	else
> +		off = 0;

Can you restrict this to NF_NAT_MANIP_DST?
I don't want predictable src port conflict resolution.

Probably something like (untested):

find_free_id:
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		off = (ntohs(*keyptr) - ntohs(range->base_proto.all));
+	else if ((range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) &&
+	  	  maniptype == NF_NAT_MANIP_DST))
+ 		off = 1;
	else
  		off = get_random_u16();
