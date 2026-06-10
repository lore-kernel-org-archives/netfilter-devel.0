Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F7338E8D0
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 21:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781126894; cv=none; b=Qo1HO89CcGZ+zh//kTrEihG3qPKy7ocNIh4OOhiHwn/bg0gXFZmhySCMS00EmfMCIJkoDjTWdFSlmlWRcmhIF3h7jX2cKPGpF7kK+vH9nQPlIe7x81iZapU7Du9O3tZk2iZ1AKNOav34FiMvL4BzwoOczcv2/c4iODO9Qe2faig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781126894; c=relaxed/simple;
	bh=v27SfcyQ4BBUeISHqo8n05dfmPeR598gnjj4C0T1rFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8n522SHQjHMeYCmt5GIP9oQhopAxnpuSuuk+93Pxhs9gzuF4MFYHhfj9/HCaMbKMdUTmzu12UCYJ36fJKNMxkybptiRSg/6k1WDsxXa4CO10ZupWbV6S3298fefDngoGMFOSo+PVuvEYLBrfmGGKPwUOuxTQGjCe+1PYOAp8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WYCf5WD9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WYCf5WD9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8D4tbFqKy1NBuCaKPits8dZyZEsytGSWshXH2QHmPgU=; b=WYCf5WD9vmv/dQAPP+apJTrU96
	fV/LtA3TxQtlcq6xQpe7gjV2ZCXo8enUDIS1VdZGi7hGXn50xokLQA+ndB0+hZxJGx9frmXa0LrxZ
	cHdVo3EutHdyBbNHCJ6kftwHl3uZoih/Sy78fE30S2gKxfOKpu2Ny6JFcyWB/nOK/ZRdQDyrPpBJQ
	bkVBGe3Z2uCVRTFJM7pMnTAy7FanzIvdjedqACrX2jgF4MDUTgg9DDiowpvfltDyJe0HKEk6WfNwC
	jz4fa5jwWakzG3KJu92Kqv5yd7rIyITZJ+/7B0SgmbWok6y9nR4IJqDk/itDLNuAe+Or2TeK2XVfs
	jlUMNO0w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wXQT5-000000004tq-0ymO;
	Wed, 10 Jun 2026 23:28:11 +0200
Date: Wed, 10 Jun 2026 23:28:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] profiling: Include unistd.h to avoid compiler
 warnings
Message-ID: <ainW60j1XtZUij5c@orbyte.nwl.cc>
References: <20260610115723.3982210-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260610115723.3982210-1-phil@nwl.cc>

On Wed, Jun 10, 2026 at 01:57:23PM +0200, Phil Sutter wrote:
> RHEL8's gcc-8.5.0 emits these warnings:
> 
> src/profiling.c: In function ‘get_signalfd’:
> src/profiling.c:32:3: warning: implicit declaration of function ‘close’; did you mean ‘pclose’? [-Wimplicit-function-declaration]
>    close(fd);
>    ^~~~~
>    pclose
> src/profiling.c: In function ‘check_signalfd’:
> src/profiling.c:42:6: warning: implicit declaration of function ‘read’; did you mean ‘fread’? [-Wimplicit-function-declaration]
>   if (read(fd, &info, sizeof(info)) < (signed)sizeof(info))
>       ^~~~
>       fread
> 
> Fixes: 868040f892238 ("configure: Implement --enable-profiling option")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
