Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977B420ADCF
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2024 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733323498; cv=none; b=VCuQ+tn/8/BL4iPdDIemgPCmz3RwVLVPBLPgayAsgBsV3cOdPqYR46WLMFs7fitNU70R30111sHgm6pP7lMH2knSGDSJT7ko/4JH2A83jQUBjb13rox7TPAwuc13oRVpqg0jaWLcDKqvtXtrapWI4Myp1PfeEv2qB/D6M6W4nXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733323498; c=relaxed/simple;
	bh=IlEjRgoA5LVn2cQmEHddw8awqSVoXujSX5tdXEBFNNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OE+L5efAbMlqfHTsbQDPdj+2qiB+R8JaSWaxMrJ+wS4gYO1IoXmkcDOO6FZ1oi1X4BFse2Ck5kuL7TG4OIw8vjk/ui5Y1bhRI2RP7hqQ/+4noUDT/opvbT/zg10MbvLbsMt+DlaO9hykgpuzjYd9I9m4Bc1Gy1kfLMUuqBPveRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=58192 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tIqcT-009Blt-36; Wed, 04 Dec 2024 15:44:51 +0100
Date: Wed, 4 Dec 2024 15:44:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: Re: [PATCH libnftnl,v2 0/5] bitwise multiregister support
Message-ID: <Z1Bq4N5p-MJIhv4N@calendula>
References: <20241119154245.442961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241119154245.442961-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

Hi,

On Tue, Nov 19, 2024 at 04:42:40PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> This is just a rebase and reposting original series from Jeremy.
> 
> I removed a userspace check to disallow to combine _DATA and _SREG2
> which kernel should reject already.

I have pushed out this now that 6.13-rc1 is out, so it gets more testing.
