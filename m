Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124293;
	b=Z+SM/yIiURjmjqi3v5jch0ZqDxnKGdQn5mnokQVBX1nra90KCDK0k71BdNHVwFlaTpHa
	 xm7KptRoWrDk3kHJlSQmLQBnS74chmac0h1Bjqy+GVyxB2qtL5NdKNfEMZtpJ3sHaBx14
	 vq46nrcxl5E97WYHhT1vSgaoysnJP8ZLmCKvCz2R3jk0/fXLIQu+0JXMPuMi0+kHEqkLW
	 aCFFWaBES5snSTFm1Dw1HXghW86rpZv5OpqO/aCulBUWobNouC7EjXTwITmkN1bqxyNRQ
	 b8/NFuObnfxUtZg/3MOBXAO5JMvGdWCARWP+Olf5zgKTQpcZXkaLNb6XL+NiwnvvcFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124293;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SBcXgEusSI+1WzBfdHvV/lbgSHvXGeUjeOB0JOL0Zko=;
	b=lfIfNO9uaeDVLd5H7ozO8OjdmRua5i61PAbrM/RO5W5A42b4O1IwpJEpsKnz53X2wArZ
	 Mm4BCHsvVVPXDwGnYn1tFrFrW7haEZQB1HxqtcT9zEiALczFvWXy8BEJSLvdUzAePOqxN
	 X6LJ+HRIDqbKp5M/BIIje6Sgkptuyk9dOP6bDTApjbxV4FlroZJG6Ch3Yq04PSdqoqGO+
	 SJy6ZWW8HntJhdGf8fkzYLE0l/NLugZaVr26jx++wtzXMjuovSMKMhIt+svbH9ipICNBp
	 OrKmY73B1z0SSfABiK+w3DcWnMEG8HHni3KrDa++gyHk7lqJ4DAGw4/klSFgZvEO3sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5222A606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 18:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5222A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1F6B9609D0; Tue, 27 Oct 2026 19:04:50 +0100 (CET)
Date: Tue, 27 Oct 2026 19:04:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v6 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <auDnvef-koFIKKft@strlen.de>
References: <20261027133331.25979-1-fw@strlen.de>
 <a8a94db7-7b61-4619-e7d9-920e775814b7@netfilter.org>
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
In-Reply-To: <a8a94db7-7b61-4619-e7d9-920e775814b7@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> Hi Florian,
> 
> I'm absolutely sure that your efforts to replace the custom hash 
> implementation in ipset with rhastable is the proper way to solve the many 
> problems lurking in the current codebase. Which are sometimes nearly 
> impossible to solve anyway, without a complete redesign. So looking at the 
> sashiko comments, I think the end of the long journey is not far away!

Its farther away than ever.  Totally demotivating.

Each new iteration moves goalpost and raises new concerns not seen
before, or raised by other models.

I hope I can retire within the next few years, the AI age sucked all the
fun out of it.
