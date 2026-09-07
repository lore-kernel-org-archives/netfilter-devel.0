Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F4351D51E;
	Mon,  7 Sep 2026 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799078; cv=none; b=sPkAsJ2C6bvmgg6YfLsalruf2tdnqEPdlo0HGIXVK3FISAtsSifD6DJN7jeEgLIu3QYchlpz0VBJXZ1WU8ljon1OK1BFONOBydj17ijaesF5kQAj3By4LO6nTVq1SRiG6QjdE9MA9UUJnsXiBdSSq3L38WL0dQkWEhqLtTtBGRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799078; c=relaxed/simple;
	bh=woCwE/38+0WF//4ibQW984JWWQ9q5/+EreO6T8N0wYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/NVLz6bqoHuvxFkJhCTk11d1XUXpgWA9lTbY6q4o1tvtcW1vHzS2Ng0JU5INSw2bL4UXP/HHqIyCdlMUmkoeg7j/Ap0j2JEwEFT79364JEkYT6Ej54rGWxqeQk/tPdrVonZH+PlAtrtLYMeYg4deaIqkWfMIrpmZSbdErv2gBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WVEWiuCH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WVEWiuCH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788799065;
	bh=kMSV+W27XFwyfRMOAa+7gJJ8b6eShRCGPy6NZRkgGyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVEWiuCHEvZxQy/kVTJzVkiPtqcljmvLY6gjfqL5KIxfw45F2u1WKSACPJdNiQCOZ
	 Y8A2w75Bv166I+yx5IoHXS7l+meKwPyyFOk7z8c3CiiynUZM/TeDqNh4/Uao0cqE0/
	 5DubB2ae7fIH3lfLahcrTHXjRrn5Wcm4AqTLd3xe2a4O2C/QCAoN7yqdPQuK3Rn4Gs
	 JCIChE68ptlvrmJ27XGJZjAR7AzuFIZRBn0FZS/HKUeQF5f2A5Ox+C+DoO9oOawKsu
	 DeWj5DwVqf9t5isTVpCC8mp0PpjRRvrnye2f+NBUeHxKgjK/tKaxNYzWP0ThhgW5/n
	 3nCGpmuEiqdXQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7A53A607A3;
	Mon,  7 Sep 2026 18:37:45 +0200 (CEST)
Date: Mon, 7 Sep 2026 18:37:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chenguang Zhao <chenguang.zhao@linux.dev>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack_amanda: fix port value truncation
Message-ID: <ap7oV1cftWpjsBiJ@chamomile>
References: <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
 <214d51c6-a71b-4b93-8dd7-6bd1c02b4c3f@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <214d51c6-a71b-4b93-8dd7-6bd1c02b4c3f@linux.dev>

On Mon, Sep 07, 2026 at 02:56:13PM +0800, Chenguang Zhao wrote:
> 
> 在 2026/9/7 07:37, Aamir Ahmed 写道:
> > amanda_help() uses simple_strtoul() to parse the port number from
> > Amanda CONNECT replies, passing the result directly through htons()
> > into a __be16.  simple_strtoul() returns unsigned long, so values
> > above 65535 are silently truncated by the implicit conversion to u16
> > inside htons().
> >
> > The existing check "port == 0 || len > 5" is insufficient: it
> > catches values that truncate to zero (e.g. 65536) and strings longer
> > than 5 digits, but misses values 65537-99999 whose u16 truncation is
> > non-zero.  For example, port 65537 becomes port 1, creating a
> > conntrack expectation for an unintended port.
> >
> > Parse into an unsigned long and explicitly reject values above 65535
> > before the htons() conversion, mirroring the pattern used by the FTP
> > helper's get_port() and the recent IPVS FTP fix (commit
> > e625a9477d12).

Please, specify target tree. This must go to nf-next.
