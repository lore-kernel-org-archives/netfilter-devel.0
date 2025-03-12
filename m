Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8241ADC6C
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810145; cv=none; b=jzXyyS4s16JAU9HxZ7SAjIq4I1wtFxtnRRadg8GDwrIyiUFpDuKISmQsBFcrSfQ1q+uNRztjKo6Vs3ZZ6aXWUd6ZfuEiVUkc8jRPziy5EIrInKO46y2rAl4fNr0NRXv2CoLVAsOavhZOzZ2WMHmdnMZAwXKIiRyV6qvfO6H3SQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810145; c=relaxed/simple;
	bh=vMEeKxxWSjuF5OLeVfzHT1zbcYKG/VIfAORERLZ7ohs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/nzREv3rblXIwgtYw9lmyfqt1r9duz6y4ZQK88Q/hE/XnYUKDAMi552HjGvNFUiztcr+bEqAhQYflFg//otS/AJ3Zg6oFXewrWmXdD4/O3o/PfVyxi6kqlQRWjkIf04FnVpoqOOK7rRTMGSlqVgfrW6+XXECOMqkpiMR5ZRtb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TcmmIZes; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YcAGetB4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TcmmIZes";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YcAGetB4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C4E1060298; Wed, 12 Mar 2025 21:09:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741810140;
	bh=aODNotGzEeIuSC2/AxDKiqoRG/ZwsZN4Wo28BnIk+Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TcmmIZesLYc02/9FV+HW3/GY1GPKV8cRsp8yWh5A7ggNqfbr7I/XvIIqyKOjkHlcQ
	 NaccQ/2SRrm3V4SgnU9J9HYCXpvgky+YzYsUcXjn2NCVD3+1xRUBkJCHyQbK50BVVg
	 U/5LPY0nQK0gTsAmA2ZkMay38mm8NAbJSr9OoHH6gtmLOs6Jpab+K5Zw1+erpY4Tjs
	 9jC/QNQtcj9ntFi1T/OPU/QYCLsYPRLYqSEBk9u/oIv8IDF2cTe80lLr3AQL/WxF5Q
	 eKbMChGdZZ+/e2D+DdELc92uqGE8YmHJWQbWfeYeqIYiFooaSu3IQgYRkxs/YAZ8bV
	 pi1MhcEUc35sw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BD63460298;
	Wed, 12 Mar 2025 21:08:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741810139;
	bh=aODNotGzEeIuSC2/AxDKiqoRG/ZwsZN4Wo28BnIk+Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YcAGetB4mpZ5KdAF8PDXrvqAj76HIofdY+LdQNboBhkGDCdhLD7ulLKtaOp1TmMVZ
	 +chAdEmTxI5jkiIc8G5yKHDHPYwebfIqd3clidSUUC9aw+AtIcTe4HmyrDhiAGYCif
	 f5/vxuIcGa+/6FGYHa4lQnJdTuMHzVg3NRmc/Tzw04V/smgr6VJPr+9Bz7WDn7zzP+
	 vcJSfon83r7wqgY4YI/7h4urLrpDb6m8R1JKSZCYewkx4QOl/FpLFRffJLqgtcivU5
	 gI1iqS6fRsGD7WBMM2A8PpUFeBeYHDP+0CWIhV4QsTZXOIPcO8AAQXEytp51P8oIzJ
	 PD+ci4cPOb1vw==
Date: Wed, 12 Mar 2025 21:08:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: nicolas.bouchinet@clip-os.org
Cc: netfilter-devel@vger.kernel.org,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH v2] netfilter: conntrack: Bound nf_conntrack sysctl writes
Message-ID: <Z9Hp2Tg5efDcC_Hj@calendula>
References: <20250129170633.88574-1-nicolas.bouchinet@clip-os.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250129170633.88574-1-nicolas.bouchinet@clip-os.org>

On Wed, Jan 29, 2025 at 06:06:30PM +0100, nicolas.bouchinet@clip-os.org wrote:
> From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
> 
> nf_conntrack_max and nf_conntrack_expect_max sysctls were authorized to
> be written any negative value, which would then be stored in the
> unsigned int variables nf_conntrack_max and nf_ct_expect_max variables.
> 
> While the do_proc_dointvec_conv function is supposed to limit writing
> handled by proc_dointvec proc_handler to INT_MAX. Such a negative value
> being written in an unsigned int leads to a very high value, exceeding
> this limit.

This is applied to nf-next, thanks
