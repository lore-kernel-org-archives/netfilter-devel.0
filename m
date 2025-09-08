Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C60710E0
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757327457; cv=none; b=ivfhFDPfFgSyiC+ceg9NHWzX0CRt0O1BnTrU+QdC35KUiF416JVIQqZqhrOD4caMsH7Xrs10aS+7Rb2klTwmVUh2dK1KdYj0Oxwy0zPDvoSjejL5CBCKUqR6cdEmDAQIGtmZKvSrI5aPLhT+fEqa+BywAztQ3KAOWYTGfY4Ya0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757327457; c=relaxed/simple;
	bh=Y4/JLY0TiXHKOnZFds8EadD/WVcjNKjM72cHJE9QVWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8xrVXLgQe3yeR6Y1Sku9ilIV0RDBdLKhNUg0l0zp3Q+AFCFOFjRdv3xGCUaq1sqtqUFttw0c9Mg0nf7DOVec5xexaHUI+RebAMayzHSu+skOHO61wvhY3AnaKRc7IajNwZ+uoScStW3JlsRiYVGrFBj4q28ZH2eu3aPU4tnrIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VpM6CHML; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VpM6CHML; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VpM6CHML";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VpM6CHML"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A91C6606FC; Mon,  8 Sep 2025 12:30:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757327453;
	bh=awomUM1+m7BQkteT4b1Ajh67eM7X0DR+VfXDjC3qkIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VpM6CHMLnaO0R33MzlhnDwVNazkfHa4IOPnJoQxQa0YqfqhecazgAeGZFL+IPlFUy
	 mZiFPUKXhAQfNvowHXiyur1CN049p4xuRwBRagG04Nbwct71Auc0zJt/u3zYe/pGM9
	 Msyy1CBRyoxFjgSrMFXF7nBmRvOMtUxP+tiKOkrstTM5Q4yq8FY4nltakGzcuu4dWJ
	 nEl0MecgMCwofyC0nWiO9UY0jDSiJiuDO0vnJ2R+wAu6CsnanRiXp/APxz4SwC+iVX
	 eCyUyjibf6pYiNSi26drvjr3qyuEUXcvqduBVci/p6VNEucN9i4tSY5PgqgIBA26Wi
	 WG7xon/ktIs9Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2B7ED606EA;
	Mon,  8 Sep 2025 12:30:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757327453;
	bh=awomUM1+m7BQkteT4b1Ajh67eM7X0DR+VfXDjC3qkIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VpM6CHMLnaO0R33MzlhnDwVNazkfHa4IOPnJoQxQa0YqfqhecazgAeGZFL+IPlFUy
	 mZiFPUKXhAQfNvowHXiyur1CN049p4xuRwBRagG04Nbwct71Auc0zJt/u3zYe/pGM9
	 Msyy1CBRyoxFjgSrMFXF7nBmRvOMtUxP+tiKOkrstTM5Q4yq8FY4nltakGzcuu4dWJ
	 nEl0MecgMCwofyC0nWiO9UY0jDSiJiuDO0vnJ2R+wAu6CsnanRiXp/APxz4SwC+iVX
	 eCyUyjibf6pYiNSi26drvjr3qyuEUXcvqduBVci/p6VNEucN9i4tSY5PgqgIBA26Wi
	 WG7xon/ktIs9Q==
Date: Mon, 8 Sep 2025 12:30:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 5/5] tests: monitor: Extend testcases a bit
Message-ID: <aL6wWz5ze6zurUyT@calendula>
References: <20250829142513.4608-1-phil@nwl.cc>
 <20250829142513.4608-6-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250829142513.4608-6-phil@nwl.cc>

On Fri, Aug 29, 2025 at 04:25:13PM +0200, Phil Sutter wrote:
> Try to cover for reduced table and chain deletion notifications by
> creating them with data which is omitted by the kernel during deletion.
> 
> Also try to expose the difference in reported flowtable hook deletion
> vs. flowtable deletion.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
