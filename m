Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875720ADD6
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607254; cv=none; b=jxgkFfEf87HkZavqNaLJ0kzMQDAcZjjEUdLorfP5903jkCNdAmFPY6nCjtjiUov5zgkHqn2YFbeR5pZjfNlIRrCWfpQWYMMMqR6k0PjwCOF05Q31C9Gva+s9FIuvoQyDzKI5G9zP1TJ8PyOPljhwdiEI7fPp21dfoIE7LeKZ0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607254; c=relaxed/simple;
	bh=DbXuPUlXpPZlj5ileCNjWJJBVBv5aZDY2v6fWenxBWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBjPhBEb5xjBghq4SIAg72hSc5I+9nrjNYc/Zzcya/TesI1tfSzxCKD+8JLsyQlh3XLu3DN1BsM8B6UK1IqPXqgYXec0KFKnm9gLhqy8Z2JNv5yW+16Jgp5q5uHmidiu/4l1xu316KTagSrXagQLeeIwIHrlg9u3vhfsgpA7eT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B4ZF4TbP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B4ZF4TbP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aHXWrGeDXp5fu7TbpZ0s39jH9DaukGdY0z+rOyB+x9w=; b=B4ZF4TbPBTT4AsZNFeZnf9imc4
	B+1lIKZAlioiASDz/WK1DSFvn24+gUe2BLJIgCgZuoVeSTIRLxWJeNVWKmss7OEDoInAWlLYes8pt
	DOZ6aH7unkl2iqFvIX598FPvU/ZglrJ74nIMVs0qFALoUImw6A8n51h/ntOhxMp2yAyGol4cYZyYh
	WxZaSHI1lq+ZWo2tyrl7qyUZj0UaxmQ60Y2g2I24tnpQj8m9XN0Y7WzV5Lc4Bm31T4gHULqOy7Wsm
	YY6Q/5RnRK7eMc5f1EdZHX749Pb81eg1drpvnoJ0pQJZPPBtCEzGnm+TI445WuX2bNIsy5NN/+h3A
	PEMmj/hA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uwjw2-0000000008n-11Be;
	Thu, 11 Sep 2025 18:14:10 +0200
Date: Thu, 11 Sep 2025 18:14:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 0/8] Run all test suites via 'make check'
Message-ID: <aML1UvsBScjUG3qk@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250904152454.13054-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904152454.13054-1-phil@nwl.cc>

On Thu, Sep 04, 2025 at 05:24:46PM +0200, Phil Sutter wrote:
> Help me (and maybe others) to not occasionally forget to run this or
> that test suite in this or that mode:
> 
> Have test suites execute all variants by default (patches 1 and 2), make
> sure their exit codes match Automake expectations (patch 3) and register
> them with Automake (patch 8). Also fix for running 'make check' as
> non-root (patches 4 and 5) and calling build test suite from outside its
> directory (patch 6).
> 
> There is a "funny" problem with build test suite calling 'make
> distcheck' which behaves differently under the environment polluted by
> the calling 'make check' invocation, details in patch 7.
> 
> Changes since v3:
> - Applied the initial monitor test suite enhancements already
> - gitignore generated logs and reports
> - New patch 7
> 
> Changes since v2:
> - Drop the need for RUN_FULL_TESTSUITE env var by making the "all
>   variants" mode the default in all test suites
> - Implement JSON echo testing into monitor test suite, stored JSON
>   output matches echo output after minor adjustment
> 
> Changes since v1:
> - Also integrate build test suite
> - Populate TESTS variable only for non-distcheck builds, so 'make
>   distcheck' does not run any test suite
> 
> Phil Sutter (8):
>   tests: monitor: Excercise all syntaxes and variants by default
>   tests: py: Enable JSON and JSON schema by default
>   tests: Prepare exit codes for automake
>   tests: json_echo: Skip if run as non-root
>   tests: shell: Skip packetpath/nat_ftp in fake root env
>   tests: build: Do not assume caller's CWD
>   tests: build: Avoid a recursive 'make check' run
>   Makefile: Enable support for 'make check'

Series applied. I will follow up with the promised refactoring of
rule_add() function to finally align cmdline options with other test
suite runners.
