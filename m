Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8E22DB65
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ULJ2OijM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mRIhMuB5Ckf5cnjoawEg6Z12dWPtXqGYKWjl/Cptpa8=; b=ULJ2OijM49lPDtT0w34xZ+1fP9
	E0vwPlloxH9zLoaBMpbGjRLcJaQ86Y4Vm/xUU4A3kzCnXCiWWLITidHnBByyByukXSa7zFPifJ33g
	IViVwMpRruVHYhbD9h3uyXEG+3msvgf1r8PiuwyyL4lKLETEVgdY/OfegFyzCCqVqGipP4692QR4J
	/yAxT73OhfFfwHfrm90pVdmQ1sEuOwV5a1q7Ycedu2Alkk0VdI0kX9OUz6Tp9+APrGMoPhfew6Q47
	2lI192fuQa30r5Y/ZOF1ZLHAh/n/4o6+mqhSml369VC1cWlUz2JVAmxT2doNVCwgSQiuser0xkxye
	lvJ5we0Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rE85c-0002Ba-VV; Fri, 15 Dec 2023 14:18:53 +0100
Date: Fri, 15 Dec 2023 14:18:52 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2 0/6] Autoools silent-rules fixes
Message-ID: <ZXxSPNuPT60fbpoL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20231214164408.1001721-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214164408.1001721-1-jeremy@azazel.net>

On Thu, Dec 14, 2023 at 04:43:59PM +0000, Jeremy Sowden wrote:
> The build system defines variables similar to the ones automake provides
> to control the verbosity of the build.  However, the iptables implemen-
> tation is only partially effective and was written fifteen years ago.
> This patch-set brings the variable definitions in line with the current
> automake recommendations and fixes some bugs.
> 
> Patch 1 contains some unrelated formatting changes.
> Patches 2 & 3 remove some unused variables.
> Patch 4 brings the remaining ones in line with automake.
> Patch 5 adds a new variable for `ln`.
> Patch 6 fixes a problem with the man-page rules.
> 
> Changes since v1
> 
>   * Patch 6: missing newlines added
>   * Patch 7: dropped after feedback from Jan Engelhardt
> 
> Jeremy Sowden (6):
>   build: format `AM_CPPFLAGS` variables
>   build: remove obsolete `AM_LIBTOOL_SILENT` variable
>   build: remove unused `AM_VERBOSE_CXX*` variables
>   build: use standard automake verbosity variables
>   build: add an automake verbosity variable for `ln`
>   build: replace `echo -e` with `printf`

Series applied, thanks!
