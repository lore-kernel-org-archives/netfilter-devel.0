Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF06392822
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165128; cv=none; b=ixy/kWCBkh6rtLNSy7QKN5qp82SO+yTEZe7LqXZAOGyeLN1AXJExbq1Hb4aAEuK5mMPYRGfCJPhYFwOpJmZg1f/BhGQxcqDhtedHfngIa/u9JkVeYS3RHa2O3FwWnBxAJxOJM76LOomfvh8INbGiRIh6iw7OXaDWVAyAvBne2yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165128; c=relaxed/simple;
	bh=dlZx45gGzV7JW5rnpIgAxpeIcAYdiMFddyH2ix+2cMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJ9uR7690fMoGQ6ZVR0JdoTGAgilyY+gQMI4IxKmaeLyikbqGg4ua6shyuwbUADm0SzpyRQHWRb8speRW5nmrhmtcIctkHPq7GmOF3j8NeIh5Rv9Aru9Ww/J/CmniXMbOUejFIGEvu/BWri74RqvbqLkbkxosveDZGK2k55pU/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 921B8608DB; Tue, 14 Apr 2026 13:11:58 +0200 (CEST)
Date: Tue, 14 Apr 2026 13:11:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Xiang Mei <xmei5@asu.edu>, netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_osf: fix divide-by-zero in
 OSF_WSS_MODULO
Message-ID: <ad4g_guOwNXWxd40@strlen.de>
References: <20260410204843.64259-1-xmei5@asu.edu>
 <adqx_IBgoyAMIJ5I@strlen.de>
 <ad4elUEYrkQ18iX8@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad4elUEYrkQ18iX8@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> @@ -329,6 +332,15 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
>                 if (f->opt[i].kind == OSFOPT_MSS && f->opt[i].length < 4)
>                         return -EINVAL;
>  
> +               switch (f->wss.wc) {
> +               case OSF_WSS_MODULO:
> +                       if (f->wss.val == 0)
> +                               return -EINVAL;
> +                       break;
> +               default:
> +                       break;
> +               }
> +
>                 tot_opt_len += f->opt[i].length;
>                 if (tot_opt_len > MAX_IPOPTLEN)
>                         return -EINVAL;
> 
> If no concerns, I will post a patch.

Thanks Pablo, LGTM.
