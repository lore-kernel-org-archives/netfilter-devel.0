Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AF44EA394
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 22:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632918; cv=none; b=ktLwjLOrXRlUul7OvGYiwzjoimo2qKns2Mztzx/fZj6yrEnth0qbm97IbQ2naUuWZtcPNEWEV6559IctXeE1nxIjpW03zh4ktrEqbT12Zg7HjX8BhJv84jvAeGH1+ABTHj5aMzi0gA7JTn87ePZbdw80agfprlGoI734kpqNf3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632918; c=relaxed/simple;
	bh=14XKD4v8keXsxd3saM9/zP+oT3AxHpqsDduxyDvKt1M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tVUSXFyq27gPoUIRZBeweFxyPkDep/nCTUjk2R2oR71rMM2swA2j0kcWophuncsRC+UDXogd3YCdyJTAqR7xXQ95q8OwGmgL3nWt2Ts9PLZlQcdIVmMvPKRauYyYBLH3hw6H39EpIY2aqZrgyDx32YbWCwcvzYNcfhTTMffAHUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 4CB611003A232B; Mon, 28 Sep 2026 23:54:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 4C7E81100AD661;
	Mon, 28 Sep 2026 23:54:00 +0200 (CEST)
Date: Mon, 28 Sep 2026 23:54:00 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Matthieu Baerts <matttbe@kernel.org>
cc: Netfilter Devel <netfilter-devel@vger.kernel.org>, 
    Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
In-Reply-To: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
Message-ID: <ro0285nn-9p34-n561-q86n-1s668021npor@vanv.qr>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Monday 2026-09-28 14:13, Matthieu Baerts wrote:

>The MPTCP selftests are switching from IPTables to NFTables, and
>Clashiko reported that this part of a rule wouldn't match anything:
>
>  tcp option mptcp subtype remove-addr drop
>
>When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>added to the TCP options, it is added after an MPTCP DSS option (type
>0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>(type 30) options in the TCP options. It looks like Netfilter doesn't
>handle that, because it stops processing other TCP options when the
>expected type is found:
>
>net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>    ...
>	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
>		optl = optlen(opt, i);
>
>		if (		priv->type != opt[i])
>			continue;
>		...
>		return;  // <== it will look at the first MPTCP option
>	}

Hm, neither RFC 793 nor 9293 seem to define a general processing rule
or error-handling behavior for duplicate or repeated options within
the header of a TCP segment.

MPTCP RFC 8684 seems to acknowledge that, with:

"it may not be possible to combine all desired options .. on a single
packet"
