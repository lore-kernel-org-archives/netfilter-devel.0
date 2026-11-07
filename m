Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794070256;
	b=RVEBycG2QyS0n6/ICpEOI7JspaIDMRXp0MxEoACFZPKjuiDTBJobVrNOTVqiMFlraNIn
	 luswPnt23kQuhJjQp84RxebibDlxoO+dnIlWjKQPB0S+mAobIILYN6tAPobaLCCwYde4D
	 wVR/hDUb9JiTCOtBr4uaJhLCu1RezAkX4nV09KEn9YP54kOmGkxVKvhqYjToi6B4etRyu
	 WhcJgIEuXW0mPwtbQ0cUH0yr5RQAL2X2VEvFH1uRagItm4wPaTSaUoYvL7kx/oJiimDd2
	 OCCXmnDV4h/IhiY9Ulru1AciMQNLXitFlGgIcTcU52TEaKEx/iimA8gcsynF4Uq/gNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070256;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vXs3OIIMw2hmiIy4BQ9D+uCvvOtuiiEVleqFea6XO80=;
	b=gcC7WWhDXujlUqdRH5cAw4XjaPal2f8l0oruJXyIpocLPCWyaifVLag96R0X1dnjsFJb
	 7u9YiSVJLtb6+gSANYAiD8v0bPfoLCHIi0lEVzeiUgmus1He3fhHZ6ewqIz2ZUVEKDXqT
	 sa2K2KAnPy8jFhwBmUX/oZUiblObkQmEc9L+dyHGEtW5HYOtPfiu8Qw/zfRwADLO7fb2L
	 pqIYhvDLotSe14VPuMwY4uDZvVwd+Re4yvOVsx6CJ5LfmmjxBG/kFNPCQrVaRJ4J5gq8F
	 +W8+2V3xA2337fB7CP/kRuSNuFAR7EJC4aH3D/Q5F+mH8mxfRhxPf2eFPEu1a/qW8Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E87606A33C
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Nov 2026 16:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18E87606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8B758609FC; Sat, 07 Nov 2026 17:50:52 +0100 (CET)
Date: Sat, 7 Nov 2026 17:50:52 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: herbert@gondor.apana.org.au, kadlec@netfilter.org
Subject: Re: [PATCH nf-next v7 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <au9W7GxJ8G2S1m5x@strlen.de>
References: <20261106153808.25148-1-fw@strlen.de>
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
In-Reply-To: <20261106153808.25148-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> v7:
> - drop rhltable entirely, we need to insert at right location, not just
>   the head of the list
> - the initial rhashtable conversion now removes MULTI support,
>   re-added in extra patch that is new in this series.
> - re-target nf-next

Garbage, as usual.
