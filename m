Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A56A1FF600
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731422243; cv=none; b=FjA0vyB/a9bWx0TKMiIfIH+tum4HxcgwrVY4aZP8+EP5J5TDeNqy7AISQwy4E2NvVVAHH5AjLZ694XJp0hd34WB1CbFqWIgOf0PD6HidHzC3FNMRozHUXfFakEAWZOrTL3YYMvrn5OfZqK52IHDagLKVnJzMPU5xXDTF3JbUkOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731422243; c=relaxed/simple;
	bh=QtA/GF+6vxMWqB8r4CFrkJ61mGb7t+wrWuieyDgR+sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQTdgEMht3oHK9lQRJlpGQQJngez/0QvjhNlRpS2RHRuUOaggWPklobNjk+lPxWpT2YA+TEauvbbz6Mgo7u+p9tmf9j+RQXdebaRrTi3YL/planfiZFEi1t7JDlzToVEd5cXC3CHkQA4toUfaf6vj+GiVMN+ejQsml1JXOIj0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Q9tKLLpN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Q9tKLLpN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=grPh2ypAzNdd3rqSgUYy2K5Dn3e3AqWb1KFkKdqCi6U=; b=Q9tKLLpNolh1+VmNzkgeVX28b2
	zdU1uNlc5LlC7vw8oNs58GFFlxFZ3QQjXZvrQ+54+risQmZ2NPZFPJrX0XsUULYav9m7du9Q285Hs
	W9Z3ck/xAwz3tDoYyewpCnRleBE3s2xuKztD0ptyyo8PkS7fK8vrH1xsegdrbM3WD+zLgEyQnCGUp
	Ze/IWqZ7J98M4RJGibe3GxGsqrnOyAq4/1bIo4UYKznarv+LOUYzRygA41tQIprWYqfOpqs/eywOU
	fryIwcMVCDPXJzPndBqtngOUs3XYO0Hv25cv3mZz7YIcb/AG7U1RkHAx4k/8L8r154o+AF0Bwoyel
	YZ/Nj5uA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tArbi-0000000021c-0ecT;
	Tue, 12 Nov 2024 15:11:02 +0100
Date: Tue, 12 Nov 2024 15:11:02 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] ip[6]tables-translate: fix test failures when
 WESP is defined
Message-ID: <ZzNh9hqHlXCzy2Yc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20241108173443.4146022-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108173443.4146022-1-jeremy@azazel.net>

On Fri, Nov 08, 2024 at 05:34:43PM +0000, Jeremy Sowden wrote:
> Protocol number 141 is assigned to a real protocol: Wrapped Encapsulating
> Security Payload.  This is listed in Debian's /etc/protocols, which leads to
> test failures:
> 
>   ./extensions/generic.txlate: Fail
>   src: iptables-translate -A FORWARD -p 141
>   exp: nft 'add rule ip filter FORWARD ip protocol 141 counter'
>   res: nft 'add rule ip filter FORWARD ip protocol wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: ip6tables-translate -A FORWARD -p 141
>   exp: nft 'add rule ip6 filter FORWARD meta l4proto 141 counter'
>   res: nft 'add rule ip6 filter FORWARD meta l4proto wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: iptables-translate -A FORWARD ! -p 141
>   exp: nft 'add rule ip filter FORWARD ip protocol != 141 counter'
>   res: nft 'add rule ip filter FORWARD ip protocol != wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: ip6tables-translate -A FORWARD ! -p 141
>   exp: nft 'add rule ip6 filter FORWARD meta l4proto != 141 counter'
>   res: nft 'add rule ip6 filter FORWARD meta l4proto != wesp counter'
> 
> Replace it with 253, which IANA reserves for testing and experimentation.
> 
> Fixes: fcaa99ca9e3c ("xtables-translate: Leverage stored protocol names")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Patch applied, thanks!
