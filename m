Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9FD28F5;
	Thu,  7 Nov 2024 00:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730938782; cv=none; b=uElFdT7tnI3up7yn3yi6jNH6obLJ3aYrclfzHbOk6glZLTMTzgHML6hsK2zKNKZejp5EXNVSPLCwcG9ugfnKI+ZVL2iLldYsLS86GdmQBey9XX1eU+VRmjAYJkr5AzFnAySjb34imHAz+RSnOgm9fmjoi+En/TdvW6KANsSEhd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730938782; c=relaxed/simple;
	bh=6tMeobClGOvkuxA35H9DuJHINv3ejNFlaudJMwrc5CE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnWdkNmMGeyK4mDpOMYN1C1Ly8ZT5l7uNEVwpH6tdD3G6IrypD/kzHwC2WlmXVLxUv18LkPGIlNYk64ySl9ZaUvHIvnVs2YOjXGFcPRA83Nj4T25jYAqjXouCGKuDA5hvfFoQRLiKrjqY985t+aT6nGZmKMl3bd8EMBR2x3aLrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8E9QJ4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8E9QJ4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43605C4CEC6;
	Thu,  7 Nov 2024 00:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730938780;
	bh=6tMeobClGOvkuxA35H9DuJHINv3ejNFlaudJMwrc5CE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=F8E9QJ4S/yyM8FQE+lVUYa9F8s+Jw8xs0FRaheT9XwYnDzPNzVbV97r0YNk2Gri39
	 3SfFHkzOuNan4adzBNTktb3pUw7MpgY6oK/DdKw9KSxi35jMS3VI022na7vsQWMPCs
	 E8Ld5HagNms65UdmJyhuYzbQ7C73ZJM6VS0xvzCu1Pu6qV5Xjlfhrskv471UIucWeL
	 psOqstGQA72Mot6yjRdaw253DcpT61rWXjsRbKzXMUEZX2Ks/eVy5b07I5IV1WR/Si
	 GfmYzToj4upCNRtqkjkXkluFFn/ZnmIftiBU+C/bmXY5jIoOak+SkVX4KKIhgODPXa
	 ztQ+CbQIjqQUg==
Date: Wed, 6 Nov 2024 16:19:39 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 00/11] Netfilter updates for net-next
Message-ID: <20241106161939.1c628475@kernel.org>
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  7 Nov 2024 00:46:14 +0100 Pablo Neira Ayuso wrote:
> "Unfortunately there are many more errors, and not all are false positives.

Thanks a lot for jumping on fixing the CONFIG_RCU_LIST=y splats!
To clarify should the selftests be splat-free now or there is more
work required to get there?
