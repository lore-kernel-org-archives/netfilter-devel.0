Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCBA374FB
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 12:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707482309; cv=none; b=lZ5Q7dXtUp6f4uFfVyIqI4T4+LsOpHM+Wsq72Pa71lnXLGEi6miM30Eq5jVckW/W/uGn5JRtIKuUbLVvaFkvTACs5ZCkDUXyPE3L8Nw8zUhKaf3AxCxP9cJ3YY2nRgoGRWS/NbBCJl1ceOxeUPD5264+8sxuCgKHmeZk/UGVsqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707482309; c=relaxed/simple;
	bh=lBZ3es5kk22AslI5ar/ZTbOa6xSTtk50CijSehtDk98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcHiGe9G9plsXM5w1yScp2Uq1LhhpKuGaG9kpPEycKtDcRku8riD20Jvrbfb/EPcvpkXXnHIDmQf5eag8sXJxp4q8iUe1KdJT1O7l98WFItvqMgh2YOS+BSWuSM2LiE9kPAO9+/MAnZFzS3EZE8Ic34kmVVBuKtFdPey5eXvZxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=42874 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rYQ8z-00Ba9w-Im; Fri, 09 Feb 2024 13:38:15 +0100
Date: Fri, 9 Feb 2024 13:38:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, kernel-team@cloudflare.com,
	jgriege@cloudflare.com
Subject: Re: [PATCH] netfilter: nf_tables: allow NFPROTO_INET in
 nft_(match/target)_validate()
Message-ID: <ZcYctDP7BTBRgY+h@calendula>
References: <20240209121954.81223-1-ignat@cloudflare.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240209121954.81223-1-ignat@cloudflare.com>
X-Spam-Score: -1.7 (-)

Hi,

On Fri, Feb 09, 2024 at 12:19:54PM +0000, Ignat Korchagin wrote:
> Commit 67ee37360d41 ("netfilter: nf_tables: validate NFPROTO_* family") added
> some validation of NFPROTO_* families in nftables, but it broke our use case for
> xt_bpf module:
> 
>   * assuming we have a simple bpf program:
> 
>     #include <linux/bpf.h>
>     #include <bpf/bpf_helpers.h>
> 
>     char _license[] SEC("license") = "GPL";
> 
>     SEC("socket")
>     int prog(struct __sk_buff *skb) { return BPF_OK; }
> 
>   * we can compile it and pin into bpf FS:
>     bpftool prog load bpf.o /sys/fs/bpf/test
> 
>   * now we want to create a following table
> 
>     table inet firewall {
>         chain input {
>                 type filter hook prerouting priority filter; policy accept;
>                 bpf pinned "/sys/fs/bpf/test" drop

This feature does not exist in the tree.

>         }
>     }
> 
> All above used to work, but now we get EOPNOTSUPP, when creating the table.
> 
> Fix this by allowing NFPROTO_INET for nft_(match/target)_validate()

We don't support inet family for iptables.
