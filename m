Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEC017A2F6;
	Sat,  7 Mar 2026 18:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772907845; cv=none; b=LeD4/A0gWKXOBRlbIEq6LOCsFROxLqx4xYJ9YZze92N4v4cqc6a8S7bbUVPEznrIDF3CqZ1iKVND4Zxqpt3TLTl+IbfNOo3ElLFc13kH933QMbj/oSJD34msEv244IiYs9aEr5OVeHaZuaU/pE7h7cZ2hBhjJHAzPlw1rBsE6nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772907845; c=relaxed/simple;
	bh=EPCZ4ArqG/MUI5+2xe/0VPYA00dTt9Rg/JKVyDfs3Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWMsXs7s++jdE6U8Q1iOkVWsYL1qapyJmkeBLXJC63+zpwH7okucM6fwm2k1HqeBHEyNR3lkJjGOaz9f8DSyXyidcL5fxxl8OtDbd5fqdjUnsoTHpMMxz4nESy4hyfs3nYObft/yCns3u6qMohBWsIx18cAs/EAgsZkELNZ4oV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D65B36077F; Sat, 07 Mar 2026 19:24:00 +0100 (CET)
Date: Sat, 7 Mar 2026 19:24:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_conntrack_sctp: validate state value
 in nlattr_to_sctp()
Message-ID: <aaxtQA0BbpqTo5t1@strlen.de>
References: <aaxe43_A7rqHezJz@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaxe43_A7rqHezJz@v4bel>

Hyunwoo Kim <imv4bel@gmail.com> wrote:
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 7c6f7c9f7332..cbee99be7b5e 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -612,6 +612,9 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
>  	    !tb[CTA_PROTOINFO_SCTP_VTAG_REPLY])
>  		return -EINVAL;
>  
> +	if (nla_get_u8(tb[CTA_PROTOINFO_SCTP_STATE]) >= SCTP_CONNTRACK_MAX)
> +		return -EINVAL;

Like other, similar bug classes, I would prefer this to be solved via
netlink policy fixup.
