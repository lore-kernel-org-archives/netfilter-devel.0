Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9058002F
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707325923; cv=none; b=Cp4pKuGZAOHwp9SKWXmRLhxDQHzgZNEI5YUpdZEqqu0IzUpduL8dSxbEj0SpqD5beolYfa1KGcCHmUbSUrtF5tjBbdYpVnje5C5SVmhecFIos1nzhI0fYH0y8k0FnpHvo6qmAULHLg+KgQt1Ju6LtavjxUKT5RswBgpb8wILfic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707325923; c=relaxed/simple;
	bh=oE3CTHvt30URW1sE/1enSqeR7k4F4w4hetgTJgfzgcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWUifIoFCXaBW1Nen3bDmNB28R2456NtREn5F1y7uMuWzBAFD0ZEzZBDtNvAUVrfHAgWfbEsvvdT/418pK6gIQLunx44WODJUW/L6R4RD0BqBCOw//ji/f8ddwJsCLcV4mHbk8nDfH0sJxLtSJRhGL2zSMK3wmKr0gMK9uXSCTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=b2IdBMv7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="b2IdBMv7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pWIaozPxwaEGX+L4dPRmUCYU6jcY+0CyG5Eagfbf+S4=; b=b2IdBMv73bTCfeVGA15xfKuIng
	9fQN/bisQMY4PYTRH+PmOmrtcLKL95gSJ1yNGgvxsN/qM9cGsVmZ/zbtmteNoQtsYdaDYOxgow2iY
	/A+KtX33h+rnLri8NvJFH2S2pYfJ1Pb7u/f3OiGc+4REeAXPGiiVw2KaYDrs4IMTSK3LhvVr2TePK
	eID8uwgQRZOA28FnPloBqEL5Tb3OcRhjj+kAcMZ9f0iBKlcP8u75bz1+81sLfC5F6WPLwwgSzCqI9
	bv8+E+qmkW8uboxK/Knj8q/JJAJxA6KnWVj3Qkk9xe6ZJoYTwcDqha7s7ZIfegs3vDyiRXQ0tKVaY
	uo5rp07A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXlSp-000000006l4-1Qt8;
	Wed, 07 Feb 2024 18:11:59 +0100
Date: Wed, 7 Feb 2024 18:11:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: Sam James <sam@gentoo.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Makefile.am: don't silence
 -Wimplicit-function-declaration
Message-ID: <ZcO539zNzBXHcbre@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Sam James <sam@gentoo.org>,
	netfilter-devel@vger.kernel.org
References: <20240207021236.46118-1-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207021236.46118-1-sam@gentoo.org>

On Wed, Feb 07, 2024 at 02:12:35AM +0000, Sam James wrote:
> This becomes an error in GCC 14 and Clang 16. It's a common misconception that
> these warnings are invalid or simply noise for Bison/parser files, but even if
> that were true, we'd need to handle it somehow anyway. Silencing them does nothing,
> so stop doing that.
> 
> Further, I don't actually get any warnings to fix with bison-3.8.2. This mirrors
> changes we've done in other netfilter.org projects.
> 
> Signed-off-by: Sam James <sam@gentoo.org>

Patch applied, thanks!
