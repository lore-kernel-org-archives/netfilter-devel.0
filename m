Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86081DB361
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730155788; cv=none; b=Jn0jgmFBXawT+i7Jw+g65nmqX7nPHipX14HBPsKb3YlOWT0eYTp0QmB86qUX2GKsDj4MpeNXbnlLy+NSHbOOvwRZcPSueig6w43VgDGpPvdkA3Bz0t6M3bXHN3ALWEJ7nQG+2ycpVBq4UrBU8aBVkWkqZtuMLtl3MqHshQoF+GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730155788; c=relaxed/simple;
	bh=oLcN+bFOa/zpgvKCMlPptg2hjueIK9ZAfLHXlNxlrVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/fmD8EqPjARLmtmLIsGddx2Mc8gg2sYn9ZP6zSzd6q+wVm0EYJk2bWoPK803vjNieLT7sY/4vUlMzICZ+9mBT6dOC+WLSv0LjsFBtZKFw3X9uYGTElRUnmg6TOG2XZvFLupX+mJYFM8HwqO8ZJdRUlDqVUWl4YoQGXl7x4J/Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57172 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5YYN-004ojN-SR; Mon, 28 Oct 2024 23:49:42 +0100
Date: Mon, 28 Oct 2024 23:49:39 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
Subject: Re: [libnftnl PATCH] Use SPDX License Identifiers in headers
Message-ID: <ZyAVA6uzi-OUBtcO@calendula>
References: <20241023200658.24205-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241023200658.24205-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Oct 23, 2024 at 10:06:57PM +0200, Phil Sutter wrote:
> diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
> index 13be982324180..fc2e939dae8b4 100644
> --- a/examples/nft-chain-add.c
> +++ b/examples/nft-chain-add.c
> @@ -1,10 +1,7 @@

Maybe more intuitive to place

+/* SPDX-License-Identifier: GPL-2.0-or-later */

in the first line of this file? This is what was done in iproute2.

>  /*
>   * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
>   *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> + * SPDX-License-Identifier: GPL-2.0-or-later
>   *
>   * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
>   */
