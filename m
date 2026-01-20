Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83943A9011
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 22:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768948803; cv=none; b=EEDBLk75BgmFqOZfLfMDBtYyqsUviIl6NDLJqcNm58gXIb83UuDtbXKpTcH35HCn4OX93L7MwGHQpTDk+0MoR9rMZHUidDJL6twc7v5zwFu1w26gCMoJLuWkcSr4Bj7D/OUbWb6l7QXHZFy1XBocZGyA8b2qj6blwh0dd31yO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768948803; c=relaxed/simple;
	bh=6dsYNrP9Kuhi6L4jWVnOTmZnOpc5F+p3Mr02Zzi1JT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4o+UgS0vIDzxGOunfQxOjWoXMD/RibAECR/hIG0t7Qst38wKjuTX40krl38tTR0P7XS6y1og1EkKPRNIjSU/qzBeZImXBvHdkv3TjJA/7vcGtqVYLOsBJVeOvUQ9MRzRhr/PD8feeNhIdM5V44ta13wTna3zXVpEeoiVonthQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 80841602AB; Tue, 20 Jan 2026 23:39:50 +0100 (CET)
Date: Tue, 20 Jan 2026 23:39:50 +0100
From: Florian Westphal <fw@strlen.de>
To: Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] parser_bison: on syntax errors, output expected
 tokens
Message-ID: <aXAENobZWNLN-T0p@strlen.de>
References: <20260120122954.18909-1-fw@strlen.de>
 <22975780.EfDdHjke4D@imladris>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22975780.EfDdHjke4D@imladris>

Jan Kończak <jan.konczak@cs.put.poznan.pl> wrote:
> >  v2: prefer stdio (fprintf+memopen) vs. manual realloc of a cstring
> >  buffer, align more with nftables coding style.
> > 
> >  I'll apply this unless there are any objections.
> 
> None on my side; I should have resubmitted the patch corrected of basis
> of your comments, but I simply did not find time yet to look into that.

Applied, thanks!
If you like you could follow up so that for

'create fable filter'
you get:
Error: syntax error, unexpected string, did you mean 'table'?
expected any of: synproxy, chain, ...

string_misspell_init() + string_misspell_update() should
do the trick.
