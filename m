Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D241247283
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999801; cv=none; b=JhxOC8S465bmTrAzu+dpZ/elehPoGbGXokCG36sfDh+u7XZKp5cbqKPFqfi1u9W6IWlkkEDGDZUbvrmZw80PkmDszKBzMzi7PEw9RzVzh12iXiMezXnbtw7hGeWKx6uEG2DY5mMDNq1zjQAy9pj9dng4XqtocTS3yOOQGqP43FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999801; c=relaxed/simple;
	bh=ytLoXc6V8fch0crNfTL2rx/VnQbJvrvQ/so6KYxE0VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpA2E3t4fNbG7WXclQ9QReCXXHIJL6HcERfsiER7uXSwYR8B4aGFzEMEtyD5M7LZQLcURSeGu9FafOfMvZlAnPSFq23RUHdEhau2Ue0FWSl1+mkRxu3w+8jsm4XfybBao8rsQrtBOiPdPRBkfwvVYgspCadTx/ybFVFlvXstCMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cglzkDPP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cglzkDPP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cglzkDPP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cglzkDPP"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BA3FC607DC; Thu,  4 Sep 2025 17:29:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999797;
	bh=iv/vIbncMsxjwloGQCBuU7Z8OatTnSgANEvmdEyLHn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cglzkDPPbpKja1onearLYOPGpM51pt2KlewkjK04el12IEinxPjliWkxm4CX4FZr6
	 Qv7x//PjXVE/W3d6KMfh+2uJT3p9wgocmGnfhbmPXXxYJkbxPVZXB02+6bCD/6W9ee
	 bDU86xqtBn9VaFnqXJAWehFNKAZMgmvwXf8MbEI8yE7w38sgmxxzmpAgzbcDTmT0Zw
	 7y6oY8kOSJjmT2UcMVzkdk9yAaegyghw9OqdEf9ag0taY6Ttw2ddJfLF6+2BBEA9Qj
	 U2RLUifKm2Ep4RNwccXIEb/2rzrFNn7WME9rYDsawjWqE30KU6UFHbLATfsOgi+Soi
	 5rVnBrpPoW+WQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3B44A60713;
	Thu,  4 Sep 2025 17:29:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999797;
	bh=iv/vIbncMsxjwloGQCBuU7Z8OatTnSgANEvmdEyLHn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cglzkDPPbpKja1onearLYOPGpM51pt2KlewkjK04el12IEinxPjliWkxm4CX4FZr6
	 Qv7x//PjXVE/W3d6KMfh+2uJT3p9wgocmGnfhbmPXXxYJkbxPVZXB02+6bCD/6W9ee
	 bDU86xqtBn9VaFnqXJAWehFNKAZMgmvwXf8MbEI8yE7w38sgmxxzmpAgzbcDTmT0Zw
	 7y6oY8kOSJjmT2UcMVzkdk9yAaegyghw9OqdEf9ag0taY6Ttw2ddJfLF6+2BBEA9Qj
	 U2RLUifKm2Ep4RNwccXIEb/2rzrFNn7WME9rYDsawjWqE30KU6UFHbLATfsOgi+Soi
	 5rVnBrpPoW+WQ==
Date: Thu, 4 Sep 2025 17:29:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 2/8] tests: py: Enable JSON and JSON schema by
 default
Message-ID: <aLmwcg4B6JwfqQfR@calendula>
References: <20250904152454.13054-1-phil@nwl.cc>
 <20250904152454.13054-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250904152454.13054-3-phil@nwl.cc>

On Thu, Sep 04, 2025 at 05:24:48PM +0200, Phil Sutter wrote:
> Introduce -J/--disable-json and -S/--no-schema to explicitly disable
> them if desired.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/py/nft-test.py | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 984f2b937a077..12c6174b01257 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -1488,7 +1488,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
>  
>      parser.add_argument('-j', '--enable-json', action='store_true',
>                          dest='enable_json',
> -                        help='test JSON functionality as well')
> +                        help='test JSON functionality as well (default)')
> +
> +    parser.add_argument('-J', '--disable-json', action='store_true',
> +                        dest='disable_json',
> +                        help='Do not test JSON functionality as well')

Would it be possible to have common options to the different tests?

1/8 uses -s and -j.

I am not sure we have to worry about breaking backward for test
syntax, we only run this.

Thanks.
