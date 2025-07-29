Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C781749
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 10:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753786693; cv=none; b=nkrIjwZuqxxzuo+Laeqo2OgCdphJinGFExOKex/XiX2NfkkMZA3bPz/CgFEY2Xeozp2naebEvIx7lfrG0ab9myNT5rpasn4oSbEmOnC96u+yA1N5ho9qQVPx7aKlaBWmdoUNSkbW5vPyA3JALXrOrDFhlyzbtyiN6ieJb6l2XC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753786693; c=relaxed/simple;
	bh=cGe+1BbMrUgjaCpRTVIgXj/cLzGTUPxmxiidsUWJMT4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=g3Izm+EePAxqwGiAypQkhRIrnGrTDirBUn63gV2yMzUFIVbET0tyTlo8SvhhbtSzqVPPbGaqKF//YTxepkngrJ04fp10W5yFGM8MCdYjq/puyv5hSTQf+OqWSygwWqCBHjvtSxglomPpZkSfqQn1kU54OsxKvIdb019c1M+4Tl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=WKZQU+LG; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="WKZQU+LG"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4brsZM2HKlz3sb7m;
	Tue, 29 Jul 2025 12:50:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1753786233; x=1755600634; bh=X45dDCN0AV
	HuHEfHmSRCxlzflECI1KRo01KuAYgGmIo=; b=WKZQU+LGYyKhynKZA3kKXDrB0Q
	xwfn5TM8JanIY+ZfBv+qjCFB9ltxO7RowL36fFC2oIZapjeLUtq8JwKvr8NTOlPj
	Ml0QazCNq1UTOR6RgswNqO7qb/mcnXPR7VjlnvoqvJM7MYZ71eTGaUaZDFXkrAYO
	q2fKswpy/a+mIdhAE=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id z1G5k0avpRkT; Tue, 29 Jul 2025 12:50:33 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4brsZK2g7Hz3sb7j;
	Tue, 29 Jul 2025 12:50:33 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 563C634316A; Tue, 29 Jul 2025 12:50:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 54616343169;
	Tue, 29 Jul 2025 12:50:33 +0200 (CEST)
Date: Tue, 29 Jul 2025 12:50:33 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Florian Westphal <fw@strlen.de>, 
    netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more resistant
 to memory pressure
In-Reply-To: <aIiiIohMBjyfqT3e@calendula>
Message-ID: <ad1c9fc2-456e-9766-a2cb-352c2437207d@blackhole.kfki.hu>
References: <20250704123024.59099-1-fw@strlen.de> <aIK_aSCR67ge5q7s@calendula> <aILOpGOJhR5xQCrc@strlen.de> <aINYGACMGoNL77Ct@calendula> <aINnTy_Ifu66N8dp@strlen.de> <aIOcq2sdP17aYgAE@calendula> <aIfrktUYzla8f9dw@strlen.de> <6f32ec06-31bf-f765-5fae-5525336900c5@blackhole.kfki.hu>
 <aIiiIohMBjyfqT3e@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Pablo,

On Tue, 29 Jul 2025, Pablo Neira Ayuso wrote:

> On Tue, Jul 29, 2025 at 09:22:46AM +0200, Jozsef Kadlecsik wrote:
>> Hi,
>>
>> On Mon, 28 Jul 2025, Florian Westphal wrote:
>>
>>> Another option might be to replace a flush with delset+newset
>>> internally, but this will get tricky because the set/map still being
>>> referenced by other rules, we'd have to fixup the ruleset internally to
>>> use the new/empty set while still being able to roll back.
>>
>> If "data" of struct nft_set would be a pointer to an allocated memory area,
>> then there'd be no need to fixup the references in the rules: it would be
>> enough to create-delete the data part. (All non-static, set data related
>> attributes could be move to the "data" as well, like nelems, ndeact.) But
>> it'd mean a serious redesign.
>
> refcounting on object is needed to detect deletion of chains that are 
> still in used, rule refer to chains either via direct jump/goto or via 
> verdict map. When handling the transaction batch is needed to know what 
> can be deleted or not.

The private set data part of struct nft_set contains anything which is 
directly referenced from rules, maps? What I wanted to suggest is to keep 
the set structure part which is referenced/pointed to from rules, etc.
intact but separate the private set data part so that it could be handled 
independently.

[It seems I miss something.]

Best regards,
Jozsef
