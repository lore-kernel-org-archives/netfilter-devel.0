Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278B82CCC2
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2024 10:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727085834; cv=none; b=g1ZLkPk7aEiilZbzYq62zecBGzk/pHEuaxMYWkecdinrEfvQ9v5HE5IjMCM5cmv2eXvoBB9KZAXPeNNZNd91VlYNi3May28xf30DM02knNLrbS3Nnurz3vHXESORumVDVJ2US9ddH1fUpv9xcbfw7f0BHxxs3gDNPx+EwVhHPFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727085834; c=relaxed/simple;
	bh=rxjxCF1z0GAJIcqzju9gkqTcA+QRIRQdaHO5cQ9xTOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHnx9YRIV+nGF1yM5aKRSFCQPPBPShw8OApK50ZzlHJY7NByXbg2t+cZpsoqq9EbYxRmiej8Xs5ojm5uIaqH/hlU1mBFDErTrdv9HCoc8DZvWJPjsy8e5ddT+I+jmeJi+6voEacCepJa6skhIz/SlLAvkNlgee35wVJ/Y5lcYmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1ssfv0-00086H-PO; Mon, 23 Sep 2024 12:03:46 +0200
Date: Mon, 23 Sep 2024 12:03:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Chris Mi <cmi@nvidia.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Ali Abdallah <aabdallah@suse.de>, netfilter-devel@vger.kernel.org
Subject: Re: ct hardware offload ignores RST packet
Message-ID: <20240923100346.GA27491@breakpoint.cc>
References: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Chris Mi <cmi@nvidia.com> wrote:
> Hi Pablo & Ali,
> 
> Our customer reported an issue. I found that it can be reproduced like
> this. If the tcp client program sets socketopt linger to 0, when the client
> program exits, RST packet will be sent instead of FIN.
> 
> But this RST packet doesn't match the expected sequence, server will
> ignore it and the ct entry will be in ESTABLISHED state for 5 days.
> It seems like an expected behavior due to commit [1].
> 
> We found another commit [2] in recent kernel. We tried to set
> nf_conntrack_tcp_ignore_invalid_rst to 1.
> It doesn't work as well. And the commit message is too short. We don't
> know what's the usecase for it.
> 
> In our case, if we have the following diff, ct will be closed normally:
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> b/net/netfilter/nf_conntrack_proto_tcp.c
> index ae493599a3ef..04c0e5a86990 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1218,7 +1218,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>                         /* ... RST sequence number doesn't match exactly,
> keep
>                          * established state to allow a possible challenge
> ACK.
>                          */
> -                       new_state = old_state;
> +                       if (!tn->tcp_ignore_invalid_rst)
> +                               new_state = old_state;

Can you test if a call to
nf_tcp_handle_invalid() here resolves the problem as well?
Intent would be to reduce timeout but keep connecton state
as-is.

I don't think we should force customers to tweak sysctls to
make expiry work as intended.
