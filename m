Received: from mail-24426.protonmail.ch (mail-24426.protonmail.ch [109.224.244.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03452367D6
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 11:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745579853; cv=none; b=PYyqpRSgVxZ4YgZjMdvba3T6f9WnZkVgio2SfBWO5xOUFqWG7HcJOl3HiCDDnaLvZ8fvalXV1AmebYqH4tfCGY9um98Pu2DrI+pWhOho/Pj9+UeyDdRc2kai8pXsBxoIQUUp+sJl24i5QRQhCHGcOQUs5FtdN5yxg5uFPEwU0kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745579853; c=relaxed/simple;
	bh=ytFzhXpLASr0xxTU7d6SmO40ejcZQhx87VQ9fw3vRnc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AmYrxNTwhgSx367CKYCOvkxQZG7FAiSKsbOyNjtQzjrL9nhoHTj4i7VR4H6jR8HmonMmI/dI9ByPNLLCS+tsfIk7l8NyMUtyqpe+wZn6p5AY8jZkwDII6bV52p3HScE6J2oMhVa43nDaRJ6y4VzCWPlh7NNg//pz2TFNT8D23Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=iEi+OYGf; arc=none smtp.client-ip=109.224.244.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="iEi+OYGf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1745579849; x=1745839049;
	bh=ytFzhXpLASr0xxTU7d6SmO40ejcZQhx87VQ9fw3vRnc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=iEi+OYGfTdmx7VFRE59MY4PREOON2PhWtJ5OBATUDCmVIu8mESi5vAQ93JnSWIvsA
	 MTxAQ3BK6UgdFDy2Si8kKmlj7y0ERisaZ0ZBo6UBrN4oBQQK4WKPFQYtXvhrALkE+V
	 XAct+BvTH+QJ4qvNPTBF0kdXa0Vh8ajqJiH74BgjTSusSHJgP3FbstQ4SFHaBaNiJT
	 f13AhB2KgLYTNZ5kOETpPe8eEXKKqVB+298q0nfs0xCdjMMNv4ONYh+1PAd+spWiDQ
	 GFc11CFtyMn21f8x3/8IsN2OZKw3sKBYkwz1gz7HI/8chgobb4BeZ2D104ye18Tw27
	 KwZULRzfG0v/g==
Date: Fri, 25 Apr 2025 11:17:25 +0000
To: Florian Westphal <fw@strlen.de>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Fail to clone iptables,ipset,nftables
Message-ID: <-728miYLi9iL_eiwiHveqzHCKgCShO01Qf3Q77cQqVsSwI8y9Vv05Q-3pXc8qoDlewd_vh4oMehXQxREv1FnWX95B3JgxA4TNOl4i5lk8Y4=@protonmail.com>
In-Reply-To: <20250425062231.GA7332@breakpoint.cc>
References: <1EYtBL_6T4QRNdyaUOoY2OO_FLzCtCfv4Q7gBf28RHR_k_LB-t0IN5R7v12bgaOOSKputo826H9PZ-2EmksldVLnGVoXyMQVemTy3tMra10=@protonmail.com> <20250425062231.GA7332@breakpoint.cc>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 898ce5d384ae397fb9b8535f528a73277a38cc3b
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> I removed the file, can you try to pull again?

Working fine, since deletion of the file; thank you!

sunny
