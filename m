Received: from smtpdh20-2.aruba.it (smtpdh20-2.aruba.it [62.149.155.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0EC14293
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741367411; cv=none; b=fo6Ye8p86TeJfI+0bNeeq/E51jJCC1Sma6pRWv5iEXLX3rLTfbYykavJ4btPAhrRD+GZNbTN3MIhzxMl68lO1H+8b645Z0uxYBqqPonrhKtkWbypxmShE1x8p2a3O2QJEGgkLXoGxpzVdd3xVEMW52Oi7zaJAGRW5RI0ygO5UtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741367411; c=relaxed/simple;
	bh=uSTAuDeWfY9X+iwb2dvxo/BJZkbEgmMkmidfT5tVlv0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=pOb6gX4rTGhBaWIOzdFfmZ9CFZ0mkTgAuuKNc6ptc4+XtWR7HkTy30zfH9Hq6tjE3obqVB/U3lVw/C2kswF+rPa048ZCwB8LawUyhQ97Ngo+RqRpjnKbKKMbBHMQ9SMHUAWfM5sUvb+jvSlBWF7ABZ5YDhova0DsuGJqXvHwskI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=jqU0D4CT; arc=none smtp.client-ip=62.149.155.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="jqU0D4CT"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qbD0toap1qg4pqbD0tMGoW; Fri, 07 Mar 2025 18:10:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741367404; bh=uSTAuDeWfY9X+iwb2dvxo/BJZkbEgmMkmidfT5tVlv0=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=jqU0D4CT+WL7tJVsC9cWsENqlm8/KQaM6qqge5QPeZiKrDg5yRJx3l/vDX3JEN2co
	 DXRVqatrOnF7DDIYw/mr04rLf7hRGw89hwuQgwCmeIQOHOIKyhcqBruFVXbZDceGQd
	 52keqKWrX/tH9K7TQBj2feePB5hKNcVWcuB3ZaOJTyUTfRj80P/5gcADNw5jcz9TlF
	 EQ6l2e0CmzmDH1nBVw/EIDTLZ0ksR/g7HD/CZnWSF4lcgJhkVK3vsk61tq+/kUA5eM
	 ivlp+1YA8CZjfs34Og5EYJKbmqYrDypaVNU4M7ctSj40zSx6ffWBRP0OQuXqsoTNNZ
	 BzcCRaxvQxp9Q==
Message-ID: <1741367396.5380.29.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 18:09:56 +0100
In-Reply-To: <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>
	  <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	 <1741361076.5380.3.camel@trentalancia.com>
	 <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfLuDTDBFRYRwHDWDKQZ9vcBIrkLHo7V8csXwBoz6qTKY04FPx8amgRLD8Rc7X5Vnl3xIIYcP4ZzyVsAo1LHAJR1pI+Dle7BBHmZQowRg5wJAvoC8yMY/
 ZLH4suaixoNbJ/XYGMCV6MS3G7eFKt3gs2pEylTlGMqqZZ1i5YdBgrDtuLPYARvyrRmunstQ7uvkj8m4Sql1DQIpoD+LhjMRHJIQa9O45yOj5tg22LQp2Oa6

When using the patch, the error is not silent, it's properly logged on
stderr.

The patch solves a well defined problem: when iptables are loaded
(usually at system bootup) the network might not be available (e.g.
laptop computer with wireless connectivity), so iptables should be
tolerant to DNS unavailability, while keeping producing an error, but
not aborting the rest of iptables rules (which might be needed for
local network connectivity, for example).

Please consider that if DNS is not available, then the "evil hacker"
host that needs to be rejected in your previous example is also most
likely unreachable.

Consider that iptables can always be loaded again when Internet
connectivity becomes available (for example, by a script used to turn
the wireless connection up).

Regards,

Guido

On Fri, 07/03/2025 at 17.51 +0100, Jan Engelhardt wrote:
> On Friday 2025-03-07 16:24, Guido Trentalancia wrote:
> 
> > Of course, if the DNS is not available the "evil hacker" rule is
> > skipped when this patch is merged.
> > 
> > However the drawbacks of not applying this patch are far worse,
> > because
> > if the DNS is not available and some rules in the table contain
> > domain
> > names, then all rules are skipped and the operation is aborted even
> > for
> > numeric IP addresses and resolvable names.
> 
> A silent/ignored error is much worse than an explicit error;
> the latter you can at least test for, scripting or otherwise.
> 
