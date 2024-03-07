Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF4D127B7C;
	Thu,  7 Mar 2024 12:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814212; cv=none; b=edrncKHwlBy9EmbM+bi0tjsDobXHlcnhICyAeZ9JFwjXI2H7hRHI0woXYrizSYrzYuD1ONbG/LWAbGPYGTFBJiF1frBfr2NAdRmzD0JoXDHalcNbjRJktOQGcfH7b7WGRUU9iHI9vNWX7QWKo/I2GdxsLrTpFAKxmF2xaljpyC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814212; c=relaxed/simple;
	bh=4CPSIXlELSD3BMQE3eTCGzF708TgdVAYJ6zBkBYw5xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRkEx2Av2dJpj6sZGjcmTzLn0GiU9vpsRsD2NVb/1OiTrjs4ct/A0Axq/+gX+6zCnWRWz+yaHc4XcUTmZI+FDsLKExKMFJHecTLVkZlxgk/L23FL5fakk6VMrch/DBKQ+YgmklQbzmJr+J/mseuNaj4UzmNB+ZlnKJHUKtgU26k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riCQg-0006pG-OI; Thu, 07 Mar 2024 13:00:54 +0100
Date: Thu, 7 Mar 2024 13:00:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, edumazet@google.com,
	pablo@netfilter.org, kadlec@netfilter.org, kuba@kernel.org,
	pabeni@redhat.com, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <20240307120054.GK4420@breakpoint.cc>
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
 <20240307093310.GI4420@breakpoint.cc>
 <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jason Xing <kerneljasonxing@gmail.com> wrote:
> > This change disables most of the tcp_in_window() test, this will
> > pretend everything is fine even though tcp_in_window says otherwise.
> 
> Thanks for the information. It does make sense.
> 
> What I've done is quite similar to nf_conntrack_tcp_be_liberal sysctl
> knob which you also pointed out. It also pretends to ignore those
> out-of-window skbs.
> 
> >
> > You could:
> >  - drop invalid tcp packets in input hook
> 
> How about changing the return value only as below? Only two cases will
> be handled:
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> b/net/netfilter/nf_conntrack_proto_tcp.c
> index ae493599a3ef..c88ce4cd041e 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1259,7 +1259,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>         case NFCT_TCP_INVALID:
>                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
>                 spin_unlock_bh(&ct->lock);
> -               return -NF_ACCEPT;
> +               return -NF_DROP;

Lets not do this.  conntrack should never drop packets and defer to ruleset
whereever possible.

> >  - set nf_conntrack_tcp_be_liberal=1
> 
> Sure, it can workaround this case, but I would like to refuse the
> out-of-window in netfilter or TCP layer as default instead of turning
> on this sysctl knob. If I understand wrong, please correct me.

Thats contradictory, you make a patch to always accept, then another
patch to always drop such packets?

You can get the drop behaviour via '-m conntrack --ctstate DROP' in
prerouting or inut hooks.

You can get the 'accept + do nat processing' via
nf_conntrack_tcp_be_liberal=1.
