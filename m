Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658342288F9;
	Thu, 12 Jun 2025 23:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749771286; cv=none; b=mNdynBSwj4FfhyAvzFYzD77njmq5ZY6/X71Sa6T/tvUcUPVgYOGgKEoOglkzKYUKbmeZL2l8EkmPXVDqwYBm34zFMXLFomL1ct/Vb9UW9cbEOw6ns5a9WjNg7iAN4VCS0L2idBowuxfny1oWcWMAv9+p2W8d96CGAdJxBwdamUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749771286; c=relaxed/simple;
	bh=sJ5OyFjPXM56rQcwFq3j/Wx6q8dkOXYm7z4fI6tM4hU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YuBWaK3lLxQY0Su/imuqYxhqdH14IAFfv7ohQifBfuZMiLsvGW73Dez/++7O30S2NhC78b057Xi9ElLJUs2Bqi3Eb6N4yNeoHLWQsokNxtTz6JA9YbcIMQc7KsTAF/Zp1uAbAAW1X+MM/DFv49tDHNOqq/87WqweaaJUVNtjAZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 7EF161003A7094; Fri, 13 Jun 2025 01:25:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 7CFDC1100AF019;
	Fri, 13 Jun 2025 01:25:59 +0200 (CEST)
Date: Fri, 13 Jun 2025 01:25:59 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: Klaus Frank <vger.kernel.org@frank.fyi>, 
    Antonio Ojea <antonio.ojea.garcia@gmail.com>, 
    netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
    Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>, 
    netfilter@vger.kernel.org, 
    =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, 
    netdev@vger.kernel.org
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
In-Reply-To: <aEtMuuN9c6RkWQFo@orbyte.nwl.cc>
Message-ID: <108170pq-83n6-4s97-q6n1-71525os6rpq6@vanv.qr>
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b> <aEqka3uX7tuFced5@orbyte.nwl.cc> <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com> <aErch2cFAJK_yd6M@orbyte.nwl.cc> <CABhP=tbUuJKOq6gusxyfsP4H6b4WrajR_A1=7eFXxfbLg+4Q1w@mail.gmail.com>
 <aEsuPMEkWHnJvLU9@orbyte.nwl.cc> <cqrontvwxblejbnnfwmvpodsymjez6h34wtqpze7t6zzbejmtk@vgjlloqq2rgc> <aEtMuuN9c6RkWQFo@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2025-06-12 23:55, Phil Sutter wrote:
>
>I don't comprehend: I have to use an IPv4 transfer net because I need to
>set a source address in the generated IPv4 header. The destination IPv4
>address is extracted from the IPv6 destination address. Simple example:
>
>IPv6-only internal:     fec0::/64
>v6mapped:               cafe::/96
>external IPv4:          1.2.3.4
>internal transfer IPv4: 10.64.64.0/24

Here's a thought (experiment)...

 * make all conntrack entries and templates use IPPROTO_IPV6, even
   for IPv4 (i.e. by representing those as ::ffff:0:0/96)

 * at the time of NF_IP6_PRI_NAT_SRC or later, if a skbuff has a
   ::ffff:0:0/96 address in *both* srcaddr and dstaddr, replace the
   skbuff by one with an IPv4 header.

 * at the time of NF_IP_PRI_NAT_DST, if the ct entry is such that
   the replacement dstaddr contains one non-ffff address, replace the
   skbuff by one with an IPv6 header.

all in the hope of enabling

ip6tables -t nat -A POSTROUTING -s fec0::/64 -j SNAT --to ::ffff:1.2.3.4

so that you don't have to think about cafe::/96 or 10.64.64.0/24.
