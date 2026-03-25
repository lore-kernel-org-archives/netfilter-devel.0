Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19813A0B13;
	Wed, 25 Mar 2026 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774461564; cv=none; b=XYXSXDmVqpaCpB2QjMamZggaXGK+uTccIUHCluLOFSh1nwTi2M5rCXmisLoq79CDnGpU2gIgaqGD6vX//m/ajVFWD5dWSUdAM9wih8n/DcciCFyZjr6VV0pFjZp/P8SmxiN2MNcC7NrTn46+Mhd2TReg6VWsG9RUMximh97t0Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774461564; c=relaxed/simple;
	bh=55wjfoj7OHJ/Yrwpx+/PffPsrlu6eSVldPEERMBFMto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5LYUNaQrYoCzVUg+7QVjBf1kcCwsBGmR1oWWX0bVrvYyCWycEHH7leqO/XFoeeSDLkgCUsHM/Aw9W3ou0vvcZEJGNXVGq2MObiYyhub87wToQFPPOF7eVzGgya/xBrwrcogSZsuXewDedKhY62592NUrb9bG7JClzWLSXuh6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P+Ca03Pp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P+Ca03Pp"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 848C1600B9;
	Wed, 25 Mar 2026 18:59:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774461559;
	bh=hC3SqErnV5QOALLg28+waIy8Ptv1HifvTB5blRmrTxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+Ca03PpdJurIr7a0KUof23wT8ebLFwtB05XeWuBCHaMpsyxF9YfrqOJ3THZuAVdG
	 foAItJouiOLJFR84nujyDb/IKAF6eceUfAQkQzxf9h3TUZVpISa+mrGikex0vo5Lc8
	 F2W6LWGE1K8sPnNienw2wmmvsjb1i3ZlkHI0uNPZJN7Esx+otVt3/UF7iHMeCC+Pkp
	 jgpZCm57/17UVPq0+AvQ9HFE5KF1xoNYpveLqbGos4rIELVHsElT1cJ3mZi/6X2fH2
	 sFTuWZO1ZE/HGz+PmiPIHJLcPM0YD/wjPUttiXLWj3QnuedFDTtJRXOCNg8oYkuBS3
	 edespKfwYXzBA==
Date: Wed, 25 Mar 2026 18:59:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 00/14] netfilter: updates for net
Message-ID: <acQidRWPgfKyUYGz@chamomile>
References: <20260325131108.23045-1-fw@strlen.de>
 <acQemtlq03AZvjL7@strlen.de>
 <acQgBRbJHRqbu--0@chamomile>
 <acQgrf3J2xAPS4ec@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acQgrf3J2xAPS4ec@strlen.de>

On Wed, Mar 25, 2026 at 06:51:41PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Will you please collapse this incremental fix to 8/14 in the new PR?
> 
> I have no plans to make a new PR.

I can pick it up, I will post this PR in a few hours.

I am very sorry I found this so late.

> It took me 6h to get this out the door and it turns out its dog shit.

Maintainance is a lot work, not very well valued these days
unfortunately.

I will take care of it.
