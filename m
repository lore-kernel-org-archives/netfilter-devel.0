Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE151774A
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710867726; cv=none; b=fYVxaNqwTttFewwOqx2Wqb3/KTBZdhswbZZOP1cx5s6vCUteybAoMbgFgSyM7OnrPQHNrDQ9bkQ/GXPq5QoXUdIEA/k5O2vxjiTo81lvkco4frlIx9ZtGIrkqvSVIcEPncdoaj3oW2dq7Xy4sSR2OSB8nYEh4ZUhuWc0OR8cVi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710867726; c=relaxed/simple;
	bh=4dA/2wgbqtjw7dm6rSEHgeoMSuCw/XzR4IXqnrsO/8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiRWovCPRoOFjtoqrkbGkA12BcVFl6c95X0+Zo7m0Se/YHwJSm0xFWPSlVmUCDBiKgQXZe8qOPY2V5P5WP0aBZ9MM09ns5tj7QxQZwWn2fkap84A1+YTnRNatQrYXEtn+GCBRQ/HNqa5iM4Ngtsg2HeKI4s3jrViaHgdb8MgChU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=a3LO2eRD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="a3LO2eRD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5ImkTDIXc5OQflfEZiusHNWHkiNOUlZkJVvO7k0oZ9s=; b=a3LO2eRDW9wXs5graPlP9FB4rv
	uVCRcNM+eGpB9EeZHrwkRndeb1QIhp4gDVIdAdFzz1ndXEzl1ev8Vwm0WthcJqyaUC25UrLT090U2
	xCLLHsvlrhf7rAiv5k/9DRgPYGxLUbjjk2nWppv8DxctCOLQy35B3qdhqf5YHP/b6JtQ2lDKaiWIy
	/dB1xCOIFUetzYZZnBKfWhqr9WBpkeBUOR/SPLo0J0q3x857p/hDjRP7BEL5QRk2Jc5g3nPqLSpGm
	6ep+l1vDfWdxJ+Qt7bphW19gROSE3Tz6bO7JLPCMfY01nmA5DM6d/Untbeb59Uuekx+fjWiasTVE7
	6SalTvgQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmcWH-000000007R4-2Ke9;
	Tue, 19 Mar 2024 17:40:57 +0100
Date: Tue, 19 Mar 2024 17:40:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: Sriram Rajagopalan <bglsriram@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] iptables: Fixed the issue with combining the payload in
 case of invert filter for tcp src and dst ports
Message-ID: <ZfnAGWIgPfiS5i9G@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Sriram Rajagopalan <bglsriram@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAPtndGC29Zc6K8V3v4LStfrcnvdCNNfTmjP-Ma9dM+21f1069w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtndGC29Zc6K8V3v4LStfrcnvdCNNfTmjP-Ma9dM+21f1069w@mail.gmail.com>

On Wed, Mar 13, 2024 at 02:38:07PM +0530, Sriram Rajagopalan wrote:
> From: Sriram Rajagopalan <bglsriram@gmail.com>
> Date: Wed, 13 Mar 2024 02:04:37 -0700
> Subject: [PATCH] iptables: Fixed the issue with combining the payload in case
>  of invert filter for tcp src and dst ports
> 
> Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>
> Acked-by: Phil Sutter <phil@nwl.cc>

Patch applied manually (your mailer messed it up) and improved the
commit message a bit.

Thanks, Phil
