Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88CB224B13
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062138; cv=none; b=lqrOA1OygApDkPZ20+GKrX1EmljwmIEDnY0lIS5km6oOmW8uLmPCBU5sSf5AyfDUPdEgLNV9/rOpw2KrJujuBvvkxChjTjEJ6B85MkMhX5ZRQyAVrgHbaTxBn/89iYYhvzg1Usc9qEO++mUjJ3RWhTLhfcexUrQVgKg2WkT+soY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062138; c=relaxed/simple;
	bh=GtJ6y/q1hjZwsiXmjvbxP9A75PxszwmTTnuonQnhXrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyJv9XlKmeaZfGqnwUYWz/WFgl90UlEjf2Weyn6R0DUXTwC9mPAG0f7bofw2eZ7DXyJvERhnjb6QcGinAui4EeoTzxjwxZsAr7hH8pQx6FxM92WAn4RoojTeQ3F7m+Am/2BPdRgFcsUTVkYF7pJu+r7LmVegx6I/iAeBNuGxq/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f33HapWj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f33HapWj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787062133;
	bh=F3LGpAMS8t8IYmyDYp7IGMsEzFx4EBovazp85JLL53Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f33HapWj9DeCdc1htYSBa6t56imuzltwA4PUl5N1vpEoydiFoYjDhpd5VUlC/DNui
	 CjUnpEHAlgcEg1x3t6ZrvwuuEnko/35GiQ+YkNwcCYa+p3lwMZV7gMHPoZgTNQDgp3
	 jS3VnQTjzQvvtt6Z5p54SJI6QTXRC9S6f63jeDwaoBgyTTO6ySQjkHIS9O7gzOHiLC
	 PulwShmWf7Z15FgYIkIGBv0c3NpZhyYPquD45v5ARGHLu+DGGOh6XZP3BeOQ3yENlS
	 LEfWvE5jvZefzY+8oqjeUs1II2yaynuwh0vXtyVSdXbZQNaIRI85UcweKZUSt+PeRD
	 2wJizCKSdK07Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 28BB260057;
	Tue, 18 Aug 2026 16:08:53 +0200 (CEST)
Date: Tue, 18 Aug 2026 16:08:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, fmancera@suse.de
Subject: Re: [PATCH nf-next 3/4] netfilter: x_tables: do not print specified
 table
Message-ID: <aoRncqkQkSmSyIio@chamomile>
References: <20260818122741.1329660-1-pablo@netfilter.org>
 <20260818122741.1329660-3-pablo@netfilter.org>
 <8q4r3s01-nr0n-5on1-1s49-n37p56q00327@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8q4r3s01-nr0n-5on1-1s49-n37p56q00327@vanv.qr>

On Tue, Aug 18, 2026 at 02:55:35PM +0200, Jan Engelhardt wrote:
> 
> On Tuesday 2026-08-18 14:27, Pablo Neira Ayuso wrote:
> 
> >This is defensive, possibly this string has been already been sanitized
> >but simply print that this match/target extension can only be used for a
> >given table.
> 
> >@@ -95,8 +95,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
> > 
> > 	if (strcmp(par->table, "mangle") != 0 &&
> > 	    strcmp(par->table, "raw") != 0) {
> >-		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table, not \'%s\'\n",
> >-				    par->table);
> >+		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table\n");
> > 		return -EINVAL;
> > 	}
> 
> You have now robbed the user of information where the problem
> originated from (and thus removed an avenue on further diagnosis /
> remediation), which is one of the classic UI/UX sins[1].
>
> (There should be countless webpages out there that can explain
> better than me what's a good and what's a bad error message.)

You are right, I will keep this patch back.
