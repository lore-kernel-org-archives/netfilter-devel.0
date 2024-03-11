Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8D4207B;
	Mon, 11 Mar 2024 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710172594; cv=none; b=POeg21eYPWdS2vzWT8Kbv2Qr2yIX/bLVMKZlyjxI4dNFZ9IkkBJIrMa+QX3+qyVMQ+6SOBMXnFxs5eDt3Spd4IQ8p/fotkQj11A71lFtVKb7CcIa5qNdhRswcI/OOIPeRita92NPOXabxkmaFPcDYu8Z4smKTbetIOqYJfvxwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710172594; c=relaxed/simple;
	bh=DG7OEXhDlOilTdW8FFzCfCJIscKqicUuSOmhPk8o/nk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nj6VrDlsnezTEYLrQGUB0xIVKYny7CCKgtw9yk2taDhn0/NgxTPRMDU29NONF9InqdRT01ZLPKJZ9RPXEBkim2PYEcwsVVyHARu+Q3VCQZoCIog32Bnu6XpBJyqqJGj7r9NOg6vGlXGcF9Dd6cZooHAxGyQMZ7bplB6049A6dso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MccAnaI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MccAnaI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06303C433C7;
	Mon, 11 Mar 2024 15:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710172594;
	bh=DG7OEXhDlOilTdW8FFzCfCJIscKqicUuSOmhPk8o/nk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MccAnaI9jjP02EWVPCKRU9suVLJj9QOQ2uqAYRqyIHuSKILk3yyIPnae6IIMiC2lg
	 0I0oBfNZg5m86lV/jxkf8QqaMwOAhzAZmYyvQB6iJDC7wMhnBWb9SFTEinMp7NYsHs
	 CjImycESIQQ7yEzYLaBJhpacr9IuOne6/k2ojd3+HwAFkfI4n3gKuTzl+GUqmhvOkz
	 j6PES0LgYTA6qxbJPwYx+y06klfrzbcBtEvBw26Bl/FfNP2BByds/f+TRZd3wjNuIv
	 G5DtI6VrikYZIot4c84e/AusBzO7Jpp5pPhQNrjcuEHR/rMnfr454YVmLZ93b0VneF
	 FbZvEJO5GVmzg==
Date: Mon, 11 Mar 2024 08:56:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org,
 fw@strlen.de, pabeni@redhat.com, davem@davemloft.net,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: dccp: try not to drop
 skb in conntrack
Message-ID: <20240311085632.2d0742e6@kernel.org>
In-Reply-To: <CAL+tcoBsTjTRMiFzq_EHyYSBr9rROO-QFY5PZ3Aj-M4YDLpr=g@mail.gmail.com>
References: <20240308092915.9751-1-kerneljasonxing@gmail.com>
	<CAL+tcoBsTjTRMiFzq_EHyYSBr9rROO-QFY5PZ3Aj-M4YDLpr=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Mar 2024 14:37:25 +0800 Jason Xing wrote:
> I saw the status in patchwork was changed, but I've not received the
> comments. So I spent some time learning how it works in the netfilter
> area.
> 
> I just noticed that there are two trees (nf and nf-next), so should I
> target nf-next and resend this patch and another one[1]?

I don't think you need to repost, you CCed the right people, they
should be able to process the patches. But do keep in mind the
netfilter trees on next patches.
