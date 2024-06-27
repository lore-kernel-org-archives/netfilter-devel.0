Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC2345BE4;
	Thu, 27 Jun 2024 20:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518833; cv=none; b=bdzTURzn/+O8sb+UENWeqq2YjZ+5MP6Ef72tmwMCAHQHDktQvSeHBbT0+kTbnSmpwLUEaOUJxqIaox/HkiqU9djb4SsB+vmu0Ki8rBl2eU2SL7zCU0+8Wv5zfh31k/Q4O0uGpum6BnOSclkLnKefwLbgknQ3zS48SiaZwTm4NUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518833; c=relaxed/simple;
	bh=lmNor36AlE0LZLTQjU7uaA5/6wSG8plH3MjtRqAjcCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcrIxfFoZX2/fuORm3zXeUmuxJCYeLGP9BD9FvnBiLiN1QevO3OL1ajCX6vPkdyH93lBHrK0DAuZd+ae9+2R/54bqQNorbZW0FGdy83mO0ymYoORayHuu7Rc1qdQgAemTBJtWOlZtWWpLqHq217CUqlu2K7BbtiSWoUC8Tb5FsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9QtDCLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9QtDCLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0D7C2BBFC;
	Thu, 27 Jun 2024 20:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719518832;
	bh=lmNor36AlE0LZLTQjU7uaA5/6wSG8plH3MjtRqAjcCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L9QtDCLO+XSgW77XbvoUdiGAPx+lUtrQGtqwNGzMVoswhc7EqNGzUIUvZfCsngvpY
	 LaKC8DHpnXYdXXY4FNJaGMnJXc3wjsGRYI7YED4K6IaPjyXrvWL/owSWk76r8if6nU
	 Lwj55f7XwTk2Hu5DUuNuv2LWn4hSIH/g1xBLqMhp+0F3LJDRjCVJ6gI7j6eyaFSDBw
	 YFr8ACd9mSa2GSawoPU1qoDFHspvxwPRaZFP5+eOuIUaGzW7iZHDQoKbogWJDthNsj
	 IldpNvKykqxqX8wTEtyiBdZVsw5PCy16x9oGKTqA2VFYA1OW/6sJSyv4P18/Hvqh+Y
	 eh+bd4Jmpj9Kg==
Date: Thu, 27 Jun 2024 16:07:11 -0400
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, torvalds@linuxfoundation.org
Subject: Re: [PATCH -stable,4.19.x] netfilter: nf_tables: validate family
 when identifying table via handle
Message-ID: <Zn3Gb-QRTMrrxRoZ@sashalap>
References: <20240627004113.150349-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240627004113.150349-1-pablo@netfilter.org>

On Thu, Jun 27, 2024 at 02:41:11AM +0200, Pablo Neira Ayuso wrote:
>[ Upstream commit f6e1532a2697b81da00bfb184e99d15e01e9d98c ]
>
>Validate table family when looking up for it via NFTA_TABLE_HANDLE.
>
>Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
>Reported-by: Xingyuan Mo <hdthky0@gmail.com>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>Signed-off-by: Sasha Levin <sashal@kernel.org>

Queued up, thanks!

-- 
Thanks,
Sasha
