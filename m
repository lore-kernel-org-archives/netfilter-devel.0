Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EE11465A5
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Dec 2024 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734279352; cv=none; b=kp+OyL8Kdyk81F1//ZswtOkadYwVADd8+4X3uhwQtY2NQ3CuXnfNOkLTHaR4bfvYd4uVOjNVygBs420Ur4sCj10P9Y/q+re3reyOT1nGpjQvsval6umm0y6CSVDdp29z5V9Szd0o+36Wx6Jo1BL3NRzBCISGU/Nz6j+Sf9rv5xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734279352; c=relaxed/simple;
	bh=pCUJWSvtJUerVySMQArgjbAYAZw8YKEiU8wyN9+MrCg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mqnU1LV67Q7yKVi4kuEV/za5/9+cT+1Sm057VFGGez4zU0NcrJ5O0E0Dp0j8rS5AeJQAQQCWMGg4CCyr7NUatIs9SKDRU/rqyKDgAZV3VHGBPTHtqvSXuiK/bbx+AsI3Fs1V+OfXvLi41+W8tRJm0EnvaY4TEwufla8c/ZFUge8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 80F8819201CB;
	Sun, 15 Dec 2024 17:10:07 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id UCeCSgGIHxKW; Sun, 15 Dec 2024 17:10:05 +0100 (CET)
Received: from mentat.rmki.kfki.hu (92-249-185-160.pool.digikabel.hu [92.249.185.160])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 7A35419201C6;
	Sun, 15 Dec 2024 17:10:05 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 2FA2E14264E; Sun, 15 Dec 2024 17:10:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 2C5A2140577;
	Sun, 15 Dec 2024 17:10:05 +0100 (CET)
Date: Sun, 15 Dec 2024 17:10:05 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [ipset PATCH 0/3] tests: Fix cidr.sh, keep running despite
 errors
In-Reply-To: <20241212124733.14407-1-phil@nwl.cc>
Message-ID: <39ae5bb6-7c06-aeae-971b-7a6136ac7f97@netfilter.org>
References: <20241212124733.14407-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: maybeham 9%

Hi Phil,

On Thu, 12 Dec 2024, Phil Sutter wrote:

> The first two fix cidr.sh for testing a RHEL machine's host binary. The
> last one is unrelated but convenient when testing systems which
> expectedly fail some tests.
> 
> Phil Sutter (3):
>   tests: cidr.sh: Respect IPSET_BIN env var
>   tests: cidr.sh: Fix for quirks in RHEL's ipcalc
>   tests: runtest.sh: Keep running, print summary of failed tests
> 
>  tests/cidr.sh    |  5 +++--
>  tests/runtest.sh | 12 +++++++++---
>  2 files changed, 12 insertions(+), 5 deletions(-)

Thanks! All patches are applied in the ipset git tree. A new release is 
coming soon.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
