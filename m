Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1720F155312
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743090748; cv=none; b=J+NqDq/kcBz/vA8m9y7529SSRRxRck8q0FDwbkd4J2dbRbfUxcSunp0hf1p66EQrxzWX4B97OdgAUUaKdDXICnPi6tjXEv+5sSY8MI6p97sB5ZU2aNPWpKV+J9n/ilLZDGPeR8IL3GzaBkv3nkx5mOOtPdVv8VI+J71imcCu9mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743090748; c=relaxed/simple;
	bh=SGQ7ATC2kd/0pIjpWaBL/5tFOJ6xeRQtnApcD4Rdy8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2zqCRaxBRctOh9Q1zj+oB1rp1NfpLhPv+hg9+AfKpIIa1dtOeK51WDKNVUVgfKYf0U1yeoF5BJXfD7Zl7qkM8bGNv3Me3TOUql4qlUITEuywEIC8N3alARorNUkpduCRhpoZvjRAosp9oEt6juyUTqgzSez9Puznyd4xctxaS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CR9CJpCC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XwYvtjzQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CR9CJpCC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XwYvtjzQ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 46912603AD; Thu, 27 Mar 2025 16:52:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743090744;
	bh=mRGozsbxSAbmirEyhHrf0Dr8gh9iNcXhM/93aamXw40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CR9CJpCCK0vfRKzlqOfijZlmKLjfv6U11tSy62dSwXj2A7xT8gbvLw4Wwho3BQxNc
	 xEh95wmIebgmPNlNdYbI4VYA2L8QflRZhJRxr2ZS33x9Xa25OZm2WtfKhgQfvnjXsS
	 Jy2mdlStH9Ka4XSkC6KTnPyjovelaj51rE5Ks44P6LbnWnWck9cMWTN8IdOf/FmRtL
	 eQjsuUa/5ASYiSFIme4wn3xEDDPTft8ii+j+2tD6+g/l/yYG86QZRcvsjK3lPaYQsg
	 ts3EcNYq+J7FokTS+4y0EnXjDqUvoS3hNr4aiX9xJLJYVl9iPWAUZ3YSEGnU6Msqth
	 BCfzdoJHLIZCA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A079F603AD;
	Thu, 27 Mar 2025 16:52:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743090743;
	bh=mRGozsbxSAbmirEyhHrf0Dr8gh9iNcXhM/93aamXw40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XwYvtjzQIjBDLcT7JTlX/LM5QbciLan8uZWXTNU/tHHf6r+mAydMnMe0+Tg3H6OS/
	 g/VOwcY2W3bl12UXCLqbB4pe9fUg+JHYvGV9epb7KN6tlo0YjqK6o11yhlLw1vYRxJ
	 Gep2fkeD5NyBxKdhjEh3thFEdCML2SakUYJKQtoveYiOGEw67swKBGN7Zi8g6rD808
	 8ULyFoo8wrBqzzilaVaTdzMzxHTjQwaqnfCfo1nhwhZ6auDg2ovk5pA+rvewmExCZR
	 14oOdEeNoofcdWO4fbfVPRww66DRIQgrcCcRV3RYzD57/3gtELKAN6AUyDJ1iFvOaw
	 Rotz7a4cHgyYQ==
Date: Thu, 27 Mar 2025 16:52:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: tolerate empty concatenation
Message-ID: <Z-V0NMf-ym2FKUr1@calendula>
References: <20250324115301.11579-1-fw@strlen.de>
 <Z-Vv1R-OmC2QukpS@calendula>
 <Z-VxdrgTRO1RTdBq@calendula>
 <20250327154910.GB21843@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250327154910.GB21843@breakpoint.cc>

On Thu, Mar 27, 2025 at 04:49:10PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Mon, Mar 24, 2025 at 12:52:58PM +0100, Florian Westphal wrote:
> > > > Don't rely on a successful evaluation of set->key.
> > > > With this input, set->key fails validation but subsequent
> > > > element evaluation asserts because the context points at
> > > > the set key -- an empty concatenation.
> > > > 
> > > > Causes:
> > > > nft: src/evaluate.c:1681: expr_evaluate_concat: Assertion `!list_empty(&ctx->ectx.key->expressions)' failed.
> > > > 
> > > > After patch:
> > > > internal:0:0-0: Error: unqualified type  specified in set definition. Try "typeof expression" instead of "type datatype".
> > > > internal:0:0-0: Error: Could not parse symbolic invalid expression
> > > 
> > > Maybe block this from the json parser itself?
> > 
> > Maybe this instead? This covers for empty concatenation in both set
> > key and set data.
> 
> I don't like the idea of having to keep double-error-checks in
> both json and bison frontends.
> 
> I would prefer a generic solution where possible, unless
> there is some other advantage such as better error reporting.

I have been trying to trigger this from the bison parser, but I could
not.

I think assertion are still useful to denote something is very broken
if we get to the evaluation step with an empty concatenation.
