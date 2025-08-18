Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FA12C235D
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526588; cv=none; b=YdxPjJJLEs/KwugXqAmecmlucXyrdwQot5ICQgeQ7mDd6fx8imkYXIl4F7bzQBSr6iblpV73Ms8bIIm9kd59o/P8cWoKEvKAuYYzBz1fs2EVzKxaZtprsQpJ58jgJoEQdT7B1TLF67bv99PCZeLCjO4o0g235AcnpcGznVfB2Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526588; c=relaxed/simple;
	bh=hVRhjpH0/VDeTUFnAj514dYAL4m4SftqlLKpg1up5MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pUNgWtKb5UyPdTSs07zqG9Ux22YHmE5yOG0jzfYUFifBYUL2hXUUqnr1X+Fbju2HQhp/7BeMw201BGAwymZGxZH/IHQmgRTMOZjRz9wu7laEqYhGkOpne5iY/6894wRwT9rQwHctX3ffOzG46ZFkktXxY/sbvADepH5VbqJJhzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cMe5bYVd; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YVZL4fGv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cMe5bYVd";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YVZL4fGv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6745460298; Mon, 18 Aug 2025 16:16:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755526584;
	bh=hVRhjpH0/VDeTUFnAj514dYAL4m4SftqlLKpg1up5MA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cMe5bYVdf0oaWWfMsZBBtNsDh9QcpQ7e5Ge3/To9t5783lqBMCjt4W4D4ce/dljae
	 DYLoHoHqHtvF9npMN3MnCIFp7SjTFaLsgdYmR9W7scKlKQiQbfrEZ9/jbJxjFzPtAD
	 AVEwAEg1ME4Gi4ioKxVi9mASRUqYeL6oAF++c85hmGF3GIcZfvNqZgX1STCTWiXgZ8
	 z/StndlCl997+tLOWmrXC40jZRN+tl7d4whdFfYjbWwg7rY62wYtNxuOBIg4gWAzzp
	 SCmxaebRD8ge/hGQknsI5ztKNJRXKGvlFsEzQR9xc+y90xE9eH9Toke/S7p3rO3Jt+
	 a+lQEEq/b/oag==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C7CF460295;
	Mon, 18 Aug 2025 16:16:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755526583;
	bh=hVRhjpH0/VDeTUFnAj514dYAL4m4SftqlLKpg1up5MA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVZL4fGv+fnboJnYjoPp32d9y43q7R1yCwkdRqoqWfObNC7UP1N3qH5hccqTxrO4M
	 9GI4wxJsfjlheRs6T5UMpIzaG/63IUJ5+hNy1fu6g9c0Nb7dm9W5u0OVhCKNLLZ4ug
	 ChoU0tIiWvd5DmFbS/otaN/5yUDSEjm9O/GKFYHt9CDbV/nS3kInsOvOso+yT+n7Bv
	 XIsQxTBdyZflrLpL8rx1k6+pIrDbhHqHtD8JjWMSeZcfTjw1JJOvFFaxFp1Ue03/+r
	 Grd11Z41OrbV3MvhySTxfhWLwhD1kgCYzQflRdhTSeT+3QtssCKewAPS19m15B9H5G
	 BqNPH80f35JUw==
Date: Mon, 18 Aug 2025 16:16:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/14] json: Do not reduce single-item arrays on
 output
Message-ID: <aKM1tbmVvbzoDUqx@calendula>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>

On Wed, Aug 13, 2025 at 07:05:35PM +0200, Phil Sutter wrote:
> This series consists of noise (patches 1-13 and most of patch 14) with a
> bit of signal in patch 14. This is because the relatively simple
> adjustment to JSON output requires minor adjustments to many stored JSON
> dumps in shell test suite and stored JSON output in py test suite. While
> doing this, I noticed some dups and stale entries in py test suite. To
> clean things up first, I ran tests/py/tools/test-sanitizer.sh, fixed the
> warnings and sorted the changes into fixes for the respective commits.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

I will follow up with a patch to partially revert the fib check change
for JSON too.
