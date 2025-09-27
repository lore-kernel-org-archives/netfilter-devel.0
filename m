Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19905266B52;
	Sat, 27 Sep 2025 10:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758969924; cv=none; b=cVSMGTaK51XGJSPqOfoUKcatBhcUXYAb1O8kbiBFjIRopuqHdR6Fu/VGf34fv7WyMtKVBNldP3zrk+gXOS/8D+NlqocdupK8eh/B7JVyRLSkaXIDD32CjNrbY7nJkjA7jMRVUXSzUrPxqSAPSfoir23fHtUBUWjComVj1ik69Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758969924; c=relaxed/simple;
	bh=j5zSuE6JBN2jGXJdjugcu2LNZJXWEySrpBlGCGG0JnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3CVMK6WOaN3zye1RbZ6uRZ/3L8B40e4L1oXctfl2w8izYRNH18XAmdC/LGNMhpg/xr3SJCNdtOyNZgHYrtPsXijBoDK/i/4zNIw1DozGLOOW6s/PIbTO+JucSZFqPO4YgHnuiVMYKjeXnKbH5EvlwRcnQyrlWGtgOyGo4TKegw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F2FF86015E; Sat, 27 Sep 2025 12:45:13 +0200 (CEST)
Date: Sat, 27 Sep 2025 12:44:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	paul@paul-moore.com, eparis@redhat.com, pablo@netfilter.org,
	kadlec@netfilter.org, ej@inai.de
Subject: Re: [PATCH v3] audit: include source and destination ports to
 NETFILTER_PKT
Message-ID: <aNfAKjRGXNUoSxQV@strlen.de>
References: <20250926193035.2158860-1-rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926193035.2158860-1-rrobaina@redhat.com>

Ricardo Robaina <rrobaina@redhat.com> wrote:
> +	case IPPROTO_TCP:
> +		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
> +				 &ih->saddr, &ih->daddr, ih->protocol,
> +				 ntohs(tcp_hdr(skb)->source), ntohs(tcp_hdr(skb)->dest));

You need to use skb_header_pointer() like elsewhere in netfilter to
access the transport protocol header.

You can have a look at nf_log_dump_tcp_header() in nf_log_syslog.c for
a template.

Also please have a look at net/netfilter/nft_log.c, in particular
nft_log_eval_audit(): xt_AUDIT and nft audit should be kept in sync wrt.
their formatting.

Maybe Paul would be open to adding something like audit_log_packet() to
kernel/audit.c and then have xt_AUDIT.c and nft_log.c just call the
common helper.
