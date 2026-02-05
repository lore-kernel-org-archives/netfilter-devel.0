Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101D827C84B;
	Thu,  5 Feb 2026 10:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770285637; cv=none; b=q4UyKWNZuT6mlJBfXBmsRMX6OjKn20NuC/iEM4Z/dNsyvZ0jMLMXLyjX0S5v74p41QgYhyloCY5TbbUQrsJH2NiE+Uy9h/RPaDEm4lAY5LdDmUiXJb4MP6Qv0lzwjfyijN4QWAiwXO7qRFfUWzw1x7JKmILjwp8Cn+lsebySYpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770285637; c=relaxed/simple;
	bh=5B9bnSAZwluEByu2Xp1vo/QKDDpaca31mFo6d0sCZVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETMyY5hSYeM6OXiySugRBnHCUkWYpogOjQ6Pkj9Al3KSx3O24wqN/NzfCwg7s3Y8/msOd9cJWmM6J8SOt9fazfuLNZfkN8WWAsFfVW0jYwDT570VX+la3vniTNsh880DyN9A4WU+bdzmRrtG9ct/XM29bAOH08AnhFxWqua8K2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E269D60610; Thu, 05 Feb 2026 11:00:30 +0100 (CET)
Date: Thu, 5 Feb 2026 11:00:25 +0100
From: Florian Westphal <fw@strlen.de>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] netfilter: ftp: annotate nf_nat_ftp_hook with
 __rcu
Message-ID: <aYRqOW_kWlfcEtWM@strlen.de>
References: <aYM6Wr7D4-7VvbX6@strlen.de>
 <20260204153812.739799-1-sun.jian.kdev@gmail.com>
 <20260204153812.739799-3-sun.jian.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204153812.739799-3-sun.jian.kdev@gmail.com>

Sun Jian <sun.jian.kdev@gmail.com> wrote:
> diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
> index 0e38302820b9..f31292642035 100644
> --- a/include/linux/netfilter/nf_conntrack_ftp.h
> +++ b/include/linux/netfilter/nf_conntrack_ftp.h
> @@ -26,7 +26,7 @@ struct nf_ct_ftp_master {
>  
>  /* For NAT to hook in when we find a packet which describes what other
>   * connection we should expect. */
> -extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
> +extern unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
>  				       enum ip_conntrack_info ctinfo,
>  				       enum nf_ct_ftp_type type,
>  				       unsigned int protoff,

Patch 1 re-indents, the rest doesn't.

> diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
> index 617f744a2e3a..74811893dec4 100644
> --- a/net/netfilter/nf_conntrack_ftp.c
> +++ b/net/netfilter/nf_conntrack_ftp.c
> @@ -43,7 +43,7 @@ module_param_array(ports, ushort, &ports_c, 0400);
>  static bool loose;
>  module_param(loose, bool, 0600);
>  
> -unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
> +unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
>  				enum ip_conntrack_info ctinfo,
>  				enum nf_ct_ftp_type type,
>  				unsigned int protoff,

CHECK: Alignment should match open parenthesis
#135: FILE: net/netfilter/nf_conntrack_ftp.c:47:
+unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
                                enum ip_conntrack_info ctinfo,

Please re-indent in .c and check that checkpatch.pl doesn't complain.

Also, no need to send this in multiple patches, its one logical
annotation change.
