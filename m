Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D023E226
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366988; cv=none; b=K1SbNPSCL6ghT2ggG0klBOgBjouWESrrmgEugNcyyDui0q+hG9Q1oB5OeUz0hfGei1Hu6qlJVr8rOzoygX3uaN87pI0E3GLlfjaAlfEcAm8gm/uGkh1cIZ6kq704YQhVGQhr5RPDd0aG0e95HYfPDgCV5159vt4QZiZ5s89HroY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366988; c=relaxed/simple;
	bh=SED5wK2xAVUXLgG6aFzMhIa0z2czpChtT7p8JtfSGPQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GypV29d7Ec4K04lvp4g1xAsq3/RRclVx8TKLpoxEzBy+4IorXgp3V5HMCRkn5MaY6i3SCjQWg+oemPmvu8HtlGLqCB8ZvXvgNRjDUfrprinNwRidu16uF63zYOVQgpFDGb17WAyIYutrAQnbYrUWC6p33slxu8aAeq6Toy1iQTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id D62A31003BB141; Fri,  7 Mar 2025 18:02:58 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id D5F081100AD650;
	Fri,  7 Mar 2025 18:02:58 +0100 (CET)
Date: Fri, 7 Mar 2025 18:02:58 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Guido Trentalancia <guido@trentalancia.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
In-Reply-To: <1741362376.5380.16.camel@trentalancia.com>
Message-ID: <9rp402o4-92ss-non1-o0rq-467r79spnn42@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>  <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>  <1741361076.5380.3.camel@trentalancia.com> <1741362376.5380.16.camel@trentalancia.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Friday 2025-03-07 16:46, Guido Trentalancia wrote:

>I can give you quick example of an hostname which is allocated
>dynamically in DNS: www.google.com.
>
>If you perform:
>
>  # nslookup www.google.com
>
>then you will obtain a different IP address (or different multiple IP
>addresses) each time you run the command.
>
>Given the above, any iptables rule for such kind of host will need to
>use its FQDN instead of a statically allocated numeric IP address.

In that case of multiple queries returning multiple results (DNS
roundrobing), using hostnames in firewall rules (with or without
ignoring lookup errors) is even more wrong than before!

Because

	-s google.com -j ACCEPT/REJECT

only performs one lookup, it leads to

* accepting _too few_ hosts, meaning you erroneously reject some
  google.com connections in subsequent rules,
* or rejecting *too few* hosts, meaning you erroneously let some
  connections through in subsequent rules.

So now we've gone from 100% of the time google.com is not reachable
to randomly failing half the time attempting to load a search page.
