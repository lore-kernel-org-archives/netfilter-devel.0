Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B01C216A08
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847761; cv=none; b=LO+mqbH2CrfRkkQd1keMfA18jboRGEojYcW6qYkFcvATgLX72nITQ1lkD62xocEK+lXAFY4dWHBHbHPVeM055rYeFLVG1/kHt4T1ws5cVZIKHuIa06OI6GQ97ufc74TnL3jDa6WaCFoETehvrVnvSmaQqxc79tWBf0/9F0G0ooU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847761; c=relaxed/simple;
	bh=twEE+HLs9lMaciNmvUT+1TUF9aM0MSPO/dxKllD0VaU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rso4xoC8TY/D7qreh28mCOFdsTYRB6gS0YaUpKeI+V/BrJvG6g7WdJN3Bnk1PGgFyTefTXvMundEgLhs1qEubuXYXQ87Sy7oljOj1rKQb5SSLVgrxqFflUZnMfD6QnWGQkIeIoU3t1V6ut/q02eSknPTZKnB/K2AgvKbCs+ChZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WY3giaEw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WY3giaEw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mTNL741bCjRlGza+AtAQ7iDxM4ToKR2Br9Ca5gW/zNM=; b=WY3giaEw+g/xK9eTe4OMKKweMj
	HuxzakuI0/WV8sGNSau3pgbIil2Rh8xrzzTwNrcnPg+TM5IlQkKwBi8YfLQsjFKIcwzF8SoaGU41s
	py4Xy+qesz977spskBxJiKjPp8Z9ckiOrOyyzI9PDAIfiIOSBg7742ZhKm8fNkJtU63gamFrMv0sp
	sZ27Cmkb5JRfzlQGXsNs6dN5UFedn6R4eM+GvT+qYC+sko19+uTF9efJuk0YJTgB4vGN5XSQe4RJu
	ZaHQ47CEJAKT1nEPqW4kq3pzgJPoFksG7rleKI3wCPhPqmBdqP7AORDmLFEM4Ij5F1uoKqb9KaGd/
	t+Sy4kPg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8SZJ-000000005Kj-1TlI
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 00:02:37 +0100
Date: Wed, 6 Nov 2024 00:02:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Fix for 'make distcheck'
Message-ID: <ZyqkDXchsYeEI2qR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20241029112938.19873-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029112938.19873-1-phil@nwl.cc>

On Tue, Oct 29, 2024 at 12:29:38PM +0100, Phil Sutter wrote:
> The target performs a "VPATH build", so built binaries are not put into
> the same directory tree as the test script itself. For lack of a better
> way to detect this, assume $PWD in this situation remains being the
> build tree's TLD and check if binaries are present in there.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
