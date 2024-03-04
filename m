Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780C3D3B1
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2024 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709557129; cv=none; b=ZzOMIBc1uWm6U0yBF8m1RlHwzjng9qDDp6WzWQ8CARP25YfaBpRxCtDU+4d3V2Em9iiVF2GEypiy3rH1DC+xDX/dqNJh1i1snDmKMWTVkUgvK6cdenq9OWJvRE7e2M/m+RSBlTRmrPVT+jPtbxBKqKEo9m+DYn9KJh5e3HWz44g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709557129; c=relaxed/simple;
	bh=z2joXKzOOeSts337/tqSFlkQcH6wB8O3f1pra2NV1VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oT7EFkzpuiwHtlYIGCr3IvY9eVa+PxsA4ZtspveU0icwGWAAIqycLhh0OOJnOFIztq+wuHCIXWgSib626j+8PXvPJqR+FeJmyoAq2Wv8k955vdMdbMsI8WIU1aEW7ZhbOyOrVT/rQ87aYIyKm1rm7CwXJ1rYLBIFtFRXuj2tfBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=51916 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rh7ty-00CHHl-Hs; Mon, 04 Mar 2024 13:58:44 +0100
Date: Mon, 4 Mar 2024 13:58:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Yandt <donald.yandt@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools v2 0/3] fix potential memory loss and
 exit codes
Message-ID: <ZeXFgRt6HM30Mbng@calendula>
References: <20240302160802.7309-1-donald.yandt@gmail.com>
 <ZeXDYANYnRZJCcE8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZeXDYANYnRZJCcE8@calendula>
X-Spam-Score: -1.9 (-)

On Mon, Mar 04, 2024 at 01:49:39PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Mar 02, 2024 at 11:07:59AM -0500, Donald Yandt wrote:
> > Vector data will be lost if reallocation fails, leading to undefined behaviour. 
> > Additionally, the indices of the allocated vector data can be represented more
> > precisely by using size_t as the index type.
> > 
> > If no configuration file or an invalid parameter is provided, the daemon should exit with
> > a failure status.
> 
> Applied.

BTW, I skipped 2/3, I am not convinced this gives us much.

> I move this description chunks where they belong to
