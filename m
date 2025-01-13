Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5466C1F8EF9
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807115; cv=none; b=CrMGXk40mJexmb5T7dTiZiOG4bxnYn9M91L7L5JytQq2BXdbONKs9iGDk4niU+WpFB8b4sFkZMFHZbwRXEgyze+M+ssfsJChBfIdLB0tVyHuzC0HAHqnnneVUhafzZR6KE7z1zPOIeYGbIS0WaUTCy6Lzk1N6+y+16lKshebCCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807115; c=relaxed/simple;
	bh=9Ta1Hno1EkBbzNEklHoWBTjGgMtFs+ZuZz7dO+YFljs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujrUqz4ensNAJpVzXQEQzVYuGd7xam0xTnBajuL6VzbE+sPEKsv8NPkFO2wp9mYDHDcg11lLQH/Ck1CXXQfxKfrPwLq/2mzGZb5OMWt7yTmFiCAXxduqe12IB3cY5DEXf4xyxPLmlv6yc9Jvt+T/Qv5sID0XypL7DcSk5kL5jP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 13 Jan 2025 23:25:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: fossdd <fossdd@pwned.life>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] configure: Avoid addition assignment operators
Message-ID: <Z4WSxlAq0_Ja2o44@calendula>
References: <D711RJX8FZM8.1ZZRJ5PYBRMID@pwned.life>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D711RJX8FZM8.1ZZRJ5PYBRMID@pwned.life>

On Mon, Jan 13, 2025 at 04:08:34PM +0100, fossdd wrote:
> For compatability with other /bin/sh like busybox ash, since they don't
> support the addition assignment operators (+=) and otherwise fail with:
> 
> 	./configure: line 14174: regular_CFLAGS+= -D__UAPI_DEF_ETHHDR=0: not found
> 
> Signed-off-by: fossdd <fossdd@pwned.life>

This solution looks OK to address the musl issue that we have
discussed.

Unfortunately, we don't take patches that abuse DCO via Signed-off-by:
that looks clearly made up.
