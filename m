Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC317996B
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Pc2KA3yv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bTj4WkWbJzXtS6ovOEuJMHITReFNfoCN3qe4MrTq5x8=; b=Pc2KA3yvYBkMe2fi+gDmuPeyx4
	EFgJMwa7iwV4U2JW5s9Duv5cjgHMwaBNUQu48HQ54D23W8QSUdxvCZii2mJhEAXRmg677sjRGVacW
	QIZ1clOgPHb+vmgwd1WxCTKcBw65bowjs5x6IpJ0zy1Fp0F4y3Zo5RxkR7zSBuyNPgJCYkg38tqHN
	ioswG9pv1oHpGo1izohsDiRhq6cBklzKfi7Qyg6OrR9ZpkwGxWpYkLwA5ckvAkU0ZnRgH8oC5zgEE
	+Yrfv6O16nHrL1gcBUpknvti+SzO/HZewLKyImoXkg8+2w4QIyMOpvaFJR8+iu9IzFrSqOfaAPd1d
	7D6DhFlA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGJDA-0004Z9-Gv
	for netfilter-devel@vger.kernel.org; Thu, 21 Dec 2023 14:35:40 +0100
Date: Thu, 21 Dec 2023 14:35:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: iptables-test: Use difflib if dumps
 differ
Message-ID: <ZYQ/LP7liqkOUI0A@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20231220151353.25210-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220151353.25210-1-phil@nwl.cc>

On Wed, Dec 20, 2023 at 04:13:53PM +0100, Phil Sutter wrote:
> Improve log readability by printing a unified diff of the expected vs.
> actual iptables-save output.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
