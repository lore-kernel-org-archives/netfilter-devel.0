Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793548096;
	b=LbdKy71T+evq+epOAeXLTJcUDxSW5mp3dHUI5GoiRlKq1UuEZ/48Ls/ADQX9umaMg1Yv
	 3KDvmdq+ToOc8oSfN4buzKBGGP81SXoqJ5qA21WKnptzsmX4Ahi0opYNTPQRpKT0VH/6a
	 HtjWsg1melTGjs5RKOeduZTNRJfilNVXIACZXkVDaH+6sl29nJ5F7PsgvzHbcAyNgGbVT
	 Di6cjfvueyZ/X4iqG+DAmBM3LiMoDj456R3Vru6mBvHgI7SCHD1S2RsTuYBMNeSx+ePnN
	 hUH43kBMu1Dw3fVjTpy2Z87t/6d2d5kHKYm3vFd3v77FZMK3yyN3i5XA6EOLltfZ00w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793548096;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wd/xXlUuggarg53wnvwyEp6npUmwGa6tf3OC+NWfXwc=;
	b=P4Ni17i8EFIaOXR7nyVEv/Ta2Bt9lpgpp9Ox8gGaO9J/sSp8lxrjTTSUF2TGj+pbjOFh
	 GtGC7kPnjWUyN4SvZLrlaXmubE1Q+eJA+DrgNwGvQnRhdj/qHMMSHRw1N/Nhbo2ofJlo6
	 OYyOOULLnLE7yqkQpE6l0FKu/wkN6+RCgdyjPsaqoPJQGCBMFymntcGLAMBDcj5Oq2F7/
	 D7nODXwLYwDit2muHDuthbj+cA3GMKDVWRTv38raiy0BwU9fDyrscVG3MDhXKztjp3xSx
	 pXLidlPhmO8vCNw70s+mIWJBAA52ZJ6z26guWC9Ca1rJKCcj/MArSJR9jwgluge/ByA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hj7vkG5k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E0D606A324;
	Sun,  1 Nov 2026 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hj7vkG5k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F701F000C1;
	Sun,  1 Nov 2026 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793548095;
	bh=wd/xXlUuggarg53wnvwyEp6npUmwGa6tf3OC+NWfXwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hj7vkG5knXT2THPM5jxAEfl8kUI72cfdaFlSMMr2NQUOWkOsmkzOQkCkxdwkE+1Jd
	 aDeDkNPUXA2+HOFT3ZIpJT6IKfzQcsnLittwPYHy8MhwlUGyqiIPU/wYJLREoMAiWA
	 B+pDTflx65BcxifP8VP3QVyrD5hqqGMT22jjACIo=
Date: Sun, 1 Nov 2026 16:48:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: joasantonio108@gmail.com
Cc: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	Jaeyeong Lee <iostreampy@proton.me>
Subject: Re: [PATCH 6.12.y] netfilter: nf_conntrack_expect: add and use
 nf_ct_expect_related_pair()
Message-ID: <2026110153-headfirst-rift-1d96@gregkh>
References: <20261101-nfexp-pair-6-12-y-v1-1-56cef5744745@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101-nfexp-pair-6-12-y-v1-1-56cef5744745@gmail.com>

On Sun, Nov 01, 2026 at 03:27:30PM +0000, Joas Antonio dos Santos via B4 Relay wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> commit 4aa63842fc92de1bce59d4709a0d32e718890bb2 upstream.

<snip>

What about a backport for 6.18.y first?

thanks,

greg k-h
