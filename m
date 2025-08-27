Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48D2283680
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330863; cv=none; b=m1LG5I5EXOt6bzBhOgt3SSKgqhyM23uNqhYRNZpC7drs3K8bSdkVJaMwrLkvxdrSpiQIc+74/hP3c75fyyVVUS6MzAcz/4kQ2/XKf+7JSsKhN9DZRCsLhqQTU+UmDozCsTdCgGFJTY3L0uiZ2kdfhxE43L6eU9eBxTa+hDV2h1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330863; c=relaxed/simple;
	bh=JUMkzs/PIQX5CtGQVXylLemq9ZI0P4E1nGoiXrhrQNU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=eqDbOMpu6Vij6OV/0LYQm+eP7DDcXkTOL8IN6xAECCnxwvfiXT1dRGOOjaZJCQPKiRcFlF1ERsTlUx2lV09du/+Ffmnhn0LYREUu9XYaxDIlZMbcm/EKxnvBwOb8nzXKcRtdLx5hXZC+DUpmkLhRKFau53Yu59BzyWIJJwRgR1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 8BFCD1003D9D08; Wed, 27 Aug 2025 23:40:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 8A25511021C6ED;
	Wed, 27 Aug 2025 23:40:50 +0200 (CEST)
Date: Wed, 27 Aug 2025 23:40:50 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Jan Engelhardt <jengelh@inai.de>, phil@nwl.cc, 
    netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: make `make distcheck` succeed in the face of
 absolute paths
In-Reply-To: <aK8AsLl6A_paracl@calendula>
Message-ID: <5ss048qq-349o-8oo5-p7qr-67or900on30q@vanv.qr>
References: <90rp264n-po69-op18-1s8r-615r43sq38r0@vanv.qr> <20250827124307.894879-1-jengelh@inai.de> <aK8AsLl6A_paracl@calendula>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2025-08-27 14:57, Pablo Neira Ayuso wrote:
>On Wed, Aug 27, 2025 at 02:43:07PM +0200, Jan Engelhardt wrote:
>> `make distcheck` has an expectation that, if only --prefix is
>> specified, all other potentially-configurable paths are somehow
>> relative to '${prefix}', e.g. bindir defaults to '${prefix}/bin'.
>> 
>> We get an absolute path from $(pkg-config systemd ...) at all times
>> in case systemd.pc is present, and an empty path in case it is not,
>> which collides with the aforementioned expectation two ways. Add an
>> internal --with-dcprefix configure option for the sake of distcheck.
>
>Subtle internal detail is exposed:
>
>nft configuration:
>  cli support:                  editline
>  enable debugging symbols:     yes
>  use mini-gmp:                 no
>  enable man page:              yes
>  libxtables support:           no
>  json output support:          no
>  systemd unit:                 ${dcprefix}/lib/systemd/system
>                                ^---------^

That is unavoidable. Variables with paths are expected to be recursively
expanded -- make will do that, sh won't.
And that is why you will see '${var}' when directly echoing from configure.ac.
This is nothing specific to ${dcprefix}, you will also observe this when doing
something as trivial as

	# configure.ac
	echo "bindir: ${bindir}"
	AC_OUTPUT
