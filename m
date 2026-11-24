Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795543511;
	b=3bkQIgLKlPX/Z/7BpdiVw1Rb1PDV4o2dVtM4Rw1ECgNOWVQmxtDecSTh2B+Rg+rWXhmJ
	 PQaWILJkr8v8tqo+c0P1+Wmn8ZoVelvhm1SpPN+CoaAkDG1H5hS1flLc4KlPlPeqazgnX
	 +wIvHXZib98+yvi4wc0THFgcMyqKAX7p586JMEACrZDpyk/Zq0/7ihHrA4xMXUuoOFQ+m
	 FmN5Evz8IhpCn5wbJBrzJHjiIAPuTMNSyhFiVRm16N8ARYXH7MrpsglU1hwroQkzeE0k1
	 ozCsXZX5PB7iRM/FIAHmSh0PSmKPhJk21p/3Xi3GcqSUWgrpAyswedLfog/UXqx4VFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795543511;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=woH9dl7xfphwEkUC8KvCH6Ur56cRMavsHB1AytXt8+s=;
	b=gme8YzJXNYc9cp+16HSpr+l94ykxNxaiaSf0HBOjuAnF4Ki3VxXxnMMjnccprLZo4/S5
	 CqHVsZiw8rV97XJNBKs5N5hFVc2Obf5pjPqshAFg2FdVuiOVeA96iYfYWTaqSbHK94sfY
	 xuJYes0XxpT978yIELbIXrTqrkrCMWU9eX6Y5XdcrLpJ240eqalGsCwYryJTlbRcEG+u0
	 co7QDgnq5qhRcidx32DTux1Ky1vefJSfB9HLMHsEe4V5H/Adf3NpUbv9y9ba7nbKe2EJt
	 DQ8JCrT2XQwUkOhQb8OpQcRSdnVbcLddvEsEMRdjQyXGy6m/yNWeFAxdwU3+q5Fsc+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b="XJW/xeNT";
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAC7606A323
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 18:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DAC7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=XJW/xeNT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=woH9dl7xfphwEkUC8KvCH6Ur56cRMavsHB1AytXt8+s=; b=XJW/xeNTkc0QFjB74RNZsd6tUc
	ib+7sQhmASlDgiNPKUkChItA46o7N30IjgAdnYzO3372CSnzPHYZCZcnM/9HA+w9PMcoElZaeSewP
	h/RfrEI+HwFYEuMB0BkBJgBRk02qwFleLerHg3Dq8MRc69RELPKAfljf69c4WHwqP5WMG3x2VTlHl
	357M4aMcb0CMAI/oeOLmHq185JNtl1DzJoJoZ7G1OBCYHXnOoTEnVmqNXDaRdU7stGyAJp5k7zI96
	al2ID3Ooi5ejM7tVkmsK2dDVbnkBXuMkuyWaJY5Mp4VlXeY0zyKZ37S6qJnxWAuGeYHON3wmJ+bjm
	rU+iRhAg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xVut2-0000000084B-3ivn;
	Tue, 24 Nov 2026 19:05:00 +0100
Date: Tue, 24 Nov 2026 19:05:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/7] src: normalize set element with EXPR_MAPPING
Message-ID: <awXRzNwL7JIR8InP@orbyte.nwl.cc>
References: <20250905153627.1315405-1-pablo@netfilter.org>
 <20250905153627.1315405-2-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905153627.1315405-2-pablo@netfilter.org>

Hi Pablo,

On Fri, Sep 05, 2025 at 05:36:21PM +0200, Pablo Neira Ayuso wrote:
> EXPR_SET_ELEM provides the timeout, expiration, comment and list of
> statements, this is a shim expression.
> 
> Currently, expr_set(x)->expressions can have either:
> 
> - EXPR_SET_ELEM
> 
>         EXPR_SET_ELEM -> EXPR_VALUE
> 
> - EXPR_MAPPING, which contains EXPR_SET_ELEM in the lhs.
> 
>                       EXPR_SET_ELEM -> EXPR_VALUE
>                      /
> 	EXPR_MAPPING |
>                      \
>                       EXPR_VALUE
> 
> This patch normalizes the expression for mappings:
> 
>                                        EXPR_SET_ELEM -> EXPR_VALUE
>                                       /
> 	EXPR_SET_ELEM -> EXPR_MAPPING |
>                                       \
>                                        EXPR_VALUE
> 
> The previous representation makes it natural for expr_print() to print the
> timeout, expiration, statements and comments.
> 
> 	1.1.1.1 counter packets 1 bytes 564 : 0x00000001,
> 
> This patch adds an exception for expr_mapping_print() to stick to the
> existing representation.
> 
> The JSON representation provides this set element information too in the
> lhs, which is does not really belong there because it is exposing
> transparently the syntax tree for set elements. A workaround to retain
> compatibility is included in this patch.
> 
> The end goal is to replace EXPR_SET_ELEM by a smaller shim object, to
> further reduce memory consumption in set elements in userspace.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Git bisect identified this commit as the culprit of a regression I
noticed: Restoring the following ruleset exposes it:

| table inet t {
| 	map m6 {
| 		typeof numgen inc mod 2000 : ct zone
| 		elements = { 1 : 1 }
| 	}
| }

When listing, the element shows as '16777216 : 1', whereas:

| % bc <<< "obase = 16; 16777216"
| 1000000

The key seems to be in wrong byte order. It is not just a display issue:
nft_zones_many.sh kselftest is failing due to it which performs lookups
in such a set.

Can you quickly point at where we lost some byteorder conversion (or got
an extra one?) by your patch? I guess it missed to adjust a check. I'll
start digging through the code meanwhile, but tracing expression
manipulation in eval phase is tedious. :(

Thanks, Phil
