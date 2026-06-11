Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1B54BC035;
	Thu, 11 Jun 2026 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781210353; cv=none; b=pCmNZqTFg2TaRjcvYkgj+B98of9DxnUl9thb3oZIcucXMS7bE9+UxA/qpsszV/T6iSSQCKhLPw1hq4yiFfmQL4p88SnszFupzWzFNkjYge85SJasJd3GnKF+Q8Zi1tIM0yFUmLVagYUTcW8VLtDvt3gQ95TbSDqmP1ZYp0zi77Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781210353; c=relaxed/simple;
	bh=YRyuQnSzhv9Ufq55UC+iLQxNsvuSnZA3iTOaKIuDjkA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LE4+O5/3OV4OliyvwVSV58A7+godlwX5ye6QmPacGAgxtl1tSQ/47aWf5CH2w8JDagB14Vz0hnDZLp7FtH9xqIGu1KQ/v4IRut7yF+NlCVc8yBhD2+mbVZ0y4pGODhrHy9Z/BV7djAVJOd+lRUkiBa0OEsOahehHMgw4fYvhy/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozxoXUp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozxoXUp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F5E1F000E9;
	Thu, 11 Jun 2026 20:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781210351;
	bh=EYCoFKC4YKyuVMQ+zJl6a94PTYYiz2HFFH7B88Lkmr0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ozxoXUp6PskuuBtUdy6iagJqWpmBdonO49Y1dpnHW1t/qUZrOGNThHDasHoozmVeO
	 +JjP9v5o0Mc7x8E383kl4/ZIUdZNFo6QglBbG0locsAwDsW//GtVP8KJBnbEeREdE/
	 l+mBjsivui9tT75lx3mj0YJgDksD1JGZI2DdYF8ZiN5D046+yRpOziYgq4Vcxn2W+j
	 Y9f80AgBLlFRT5+KJxbMElHICC/VaZ/9cV0qcZvFk0Ww38U/nvJkmZY1jNqzA3fUiN
	 CFUSZP0ojcO6XU+Uc1U95VFQfetMUdb5vdoA6i+52ydgLEIJ5XR+kT4WqFswvMOHDi
	 lCqfBJ8pmm6Rw==
Date: Thu, 11 Jun 2026 13:39:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] netdevsim: tc: allow to test nf_tables
 offload control plane code
Message-ID: <20260611133910.2887266f@kernel.org>
In-Reply-To: <20260610175906.1767-2-fw@strlen.de>
References: <20260610175906.1767-1-fw@strlen.de>
	<20260610175906.1767-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Jun 2026 19:58:43 +0200 Florian Westphal wrote:
> @@ -73,7 +86,10 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
>  						  &nsim_block_cb_list,
>  						  nsim_setup_tc_block_cb,
>  						  ns, ns, true);
> +	case TC_SETUP_FT:
> +		return 0;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
>  }
> +ALLOW_ERROR_INJECTION(nsim_setup_tc, ERRNO);

As you probably seen other netdevsim offloads use explicit debugfs 
files to "fail operation X". Slightly easier to deal with, and
netdevsim is a test harness anyway. But entirely up to you.
