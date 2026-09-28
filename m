Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7C14F85B3
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 21:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632356; cv=none; b=GWJuOKGkUkfaznhFbp5cdq6xRpS95USG3n7qxmxrPj4q1auWqv2DwjvUj6nfAFtD09tE50F4oUEdz0UKG7XsLYihwhrtvXRfUkemDmZxaE+0CQhoqIB/TH3MtyER6/brbEFgIRtfaoEIreetm5yotSPAyxkCqCeWAcwv4kuYR8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632356; c=relaxed/simple;
	bh=8WRlEZyzvF80gRRtuC1Ax5j838FVIKmxefIbLrkHue0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ra6Lb1CePOFrU4eTMbBI9HQbqvyTDthqEUUvIFf3NZBdHPiD1kp1cGo/Cm7h2eLfjZAh44lVSU9vQkKqCJZg77ckrF3PKP/5cNfsKyqLudfEBnexds7wJrfsXpkIoGIvasHKu5K3XC3Pz7AWLktRbeNm/45e9sTO0HO3+J47ex4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FZ9IJmEF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FZ9IJmEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790632343;
	bh=+1QcWSlY95pvjW+ukiOih9wat/lGZB2kgFp+Z9S/gSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FZ9IJmEFt8sXYjnBCq9oikDjuh4BeO8pRYhGAYw82ZjZYuiYhRXRXs6LA5VTvm+0s
	 VlSoqck4/VJ0McbEE59DDDMJn1kjrlJRe3r89WThTnPXJCjuWxFcoObuD2lNTOd2PJ
	 pOjms2Vd0U+Heh00isETONTyYses50MfstZySVaGd8lzE+9psqcx9kCpzPHrP0m+Es
	 NVTUt5kAXOiZSYGh5WWCDWH0R7kXyveHj/mFL8863UbiC16l1MhReW913Y/hJeQrCl
	 xnmrcZIc0ae+R5y7iu0QSE0q6y5E6eCjy0EjSn+vihhsY2GVR2KlZyJvqI2753ZMUA
	 FaZ1Hs/F1Wjsw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 04E966022B;
	Mon, 28 Sep 2026 23:52:22 +0200 (CEST)
Date: Mon, 28 Sep 2026 23:52:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <arrhlKkKSSKFp4Sq@chamomile>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>

Hi Mattieu,

On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
> Hello Netfilter devs,
> 
> First, thank you for maintaining Netfilter in the kernel and the
> userspace tools.
> 
> The MPTCP selftests are switching from IPTables to NFTables, and
> Clashiko reported that this part of a rule wouldn't match anything:
> 
>   tcp option mptcp subtype remove-addr drop
> 
> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> added to the TCP options, it is added after an MPTCP DSS option (type
> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> (type 30) options in the TCP options. It looks like Netfilter doesn't
> handle that, because it stops processing other TCP options when the
> expected type is found:
> 
> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>     ...
> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
> 		optl = optlen(opt, i);
> 
> 		if (priv->type != opt[i])
> 			continue;
> 		...
> 		return;  // <== it will look at the first MPTCP option
> 	}
>     ...
> }
> 
> It looks like it shouldn't stop if the wrong subtype is found, but the
> subtype is not compared there if I'm not mistaken. Should there be a fix
> to support this case?

Would it work for you if you can specify what TCP option you want to
match? ie.
 
    tcp option[2] mptcp subtype remove-addr drop
               ^
               |
               |
       allow to specify a match at a given tcp option

Or would this be too strict for your use-case and you would prefer
that you can match it anywhere?

Thanks.

> For more details about the Clashiko report:
> 
> https://lore.kernel.org/179058242453.3145.1450534124183352369@kernel.org
> 
> 
> BTW, I'm probably missing something, but adding the following doesn't
> seem to have any effect on my side:
> 
>   nft add table ip filter
>   nft add chain ip filter OUTPUT \
>     { type filter hook output priority filter; policy accept; }
>   nft insert rule ip filter OUTPUT tcp option mptcp exists counter drop
> 
> Same with "mptcp subtype mp-capable", other subtypes or other types like
> "timestamp". But if I use ...
> 
>   nft insert rule ip filter OUTPUT meta l4proto tcp counter drop
> 
> ... then the drop is effective. Any idea what I'm missing here? :)
> 
> 
> (Also, it looks like the MPTCP suboptions are not documented in the nft
> man page :) )
> 
> Cheers,
> Matt
> -- 
> Sponsored by the NGI0 Core fund.
> 
> 
