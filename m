Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7AE20D4FA
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848212; cv=none; b=FasLr+3eBK6kZMT4zDFposKHzwXpo9CSZbX+9Y9W34oKDssRzeJeib3KtydindQWAoAUz6zCoXvPzlshKrWKujPhBBa6PXD4qvVBC0/KSoCKf2upQ7MeugJ5wlkgsaKud9skYVExzEQHJCA51GNiCOoBzjJvep9kOVzrc7lm7Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848212; c=relaxed/simple;
	bh=5FtVSyJt8cN3rH1QIuDbGavIWfw6nJpW3fj9exEXTnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKYSNy1moGCUCXttwteyx1EQxEiUjGbpozCf4zBr3uo3q3sRoc64htU6wusuPryIU5UVlc7z+r0CXh9b3EZoveg6m9kdYgvwwAfXqVh2sKV3vhMqF4cYaUMK2rZ0y/r/IzSGc+4TiaE9kC/p7d9mzTgzxN2njN+PAG+FgieEwe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59454 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8SgU-006mJ5-R9; Wed, 06 Nov 2024 00:10:04 +0100
Date: Wed, 6 Nov 2024 00:10:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] src: Eliminate warnings with
 -Wcalloc-transposed-args
Message-ID: <Zyqlyj0FKU7XeUD5@calendula>
References: <20241105215450.6122-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105215450.6122-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Nov 05, 2024 at 10:54:50PM +0100, Phil Sutter wrote:
> calloc() expects the number of elements in the first parameter, not the
> second. Swap them and while at it drop one pointless cast (the function
> returns a void pointer anyway).

BTW, will you add

-Wcalloc-transposed-args

to Makefile.am?

Thanks
