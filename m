Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD8C1D6DAA;
	Mon, 28 Apr 2025 20:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745872968; cv=none; b=YMqp8fKLQsjO0dFDX4vjbTULPuaXWw7ad+43ILkWc/5O7SS+qStmHCSOb80GRuTxdMIrgxO7WMhG6rQoJHu79R9p9iqqGt+m8bFqdwQWK/107YR81eganZFgD1Tgc2odMBlKAIK/SucpzdlGnyuZPJ8Oq/gUlg326ygI6Y8Se1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745872968; c=relaxed/simple;
	bh=C2zdz80i6gBuvh137M5BVc3/T9DXTWftX7glQeg6OrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9/2g9gry/6slEQI5GCV7ZXSsWTYnAS9veI2MDUNmtTn/kpLe0hRyuLHErFiY7NRcmOMEMAVi1gbYUnBst8mokGDOcdjVDSpigfK/KLcL+MvL9bkH0o+DxkbD+EEQLK8m9lWpjrcWtyorHVMvf0oaQeVySriImFb7zgiKG5QDSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9vSUbCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9vSUbCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FA7C4CEE4;
	Mon, 28 Apr 2025 20:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745872967;
	bh=C2zdz80i6gBuvh137M5BVc3/T9DXTWftX7glQeg6OrQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C9vSUbCA06VS87rHetFaB/Xc/eb2SXOOy5Hy08CStbDfWionIkJqU/adqpXDOhALN
	 1CgkRCu2twER7gAm00xq/sNzrXgCKsViEiXd4Uxy1yb/p39mTYDkhSGKLLiILy4vCv
	 pXUSLiFvxfCFrLEyIXFBmXsC4HtI2HlW4dEu5YOl3My8sxlXRG4+1mBmrqahfo+egN
	 845oh2760hQIDbwJ6IXYC4/3i5LPdGoBVFD9YrrkXBRtDP4OXf9brhsVKtmBncyeJ5
	 o7Xy7lSWrvxFkgnbVoZLRAv2p8a80Rhnt9tiVJHqZtj3sPZf13xcl+ng4Gx9fZYNCP
	 iyGv9W3LGPiGA==
Date: Mon, 28 Apr 2025 13:42:46 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Chaohai Chen <wdhh6@aliyun.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 horms@kernel.org, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, paul@paul-moore.com, pablo@netfilter.org,
 kadlec@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Subject: Re: [PATCH] net:ipv4: Use shift left 2 to calculate the length of
 the IPv4 header.
Message-ID: <20250428134246.147b02fe@kernel.org>
In-Reply-To: <20250427061706.391920-1-wdhh6@aliyun.com>
References: <20250427061706.391920-1-wdhh6@aliyun.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Apr 2025 14:17:06 +0800 Chaohai Chen wrote:
> Encapsulate the IPV4_HEADER_LEN macro and use shift left 2 to calculate
> the length of the IPv4 header instead of multiplying 4 everywhere.

Doesn't seem worth the churn, sorry.
