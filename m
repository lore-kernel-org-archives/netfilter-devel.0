Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92E242588C;
	Wed,  2 Sep 2026 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788387284; cv=none; b=Eh4OHmhWV/RPD/HwGVNHOiRQsosukpZLivnQZxzECTBit0vtbTLPDgXTSEsE1HkcT29jDx58UgZqzYDhiTLLAV37vAX8oF9irh7MIHeGK/03x49QE1enZMWCy2McmWkLJNxyGZKRGeTzRjmnnzqY5YvvY5eCtyw2Han2azaHOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788387284; c=relaxed/simple;
	bh=+omWPuU3czAOS+ufJ2hA0WJX6iBaB0DbWviLa47f7D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jywj1y4KuvZqkDhvIsUgA80+rMvNnx4680MdIIhG1pADL3l3Ag2wRx9/h6WHZ4WCN/+LGUX1dUdan+u4w91JiOCNOGO9sfm75imQc80ovm6hNyE4YnXEY1Jpc92J0Y1ae1ByfhOgHVL8sc1vzr6Oh/rEyODR82akXewfeLZ+QDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHW6h3NR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHW6h3NR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341A81F00ADE;
	Wed,  2 Sep 2026 22:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788387277;
	bh=gK15kQ97+7U/Zx+7r9m49LieX5MZOVt5jgSg8piKNbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHW6h3NR5bq9kM56I9ZcybHe2109NPYofkRNPk7zUKY4lRC7uconPOCvxaY6xX3sx
	 ym9q3sZKd1pyFCfRT3+HjCQbDxOIMJBJIQGh2B3bjR9bWMZOBXBKQsvQ+kjHt8xVVy
	 t4qinzeT4SRhQtR2UXDiiUQdGeDz+wir2qZ0TG3xyF5ABfmtkKeNXXchT40VVLi+Vc
	 Cnz56mh704AgOzJJ03MWp1MnskbLSnYNp5q69GXzAZIuvgW8G9wwdr5UVqOA60TwOI
	 qWJDH4pQtd0KqAaYWFdBDf6gac9eN1rXQC2ixwLPQcRgNn/IJCv9DTdGZajPJ2fMkw
	 IFYoueEZV/OQg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mukul Sikka <mukul.sikka@broadcom.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>,
	Bin Lan <lanbincn@139.com>,
	XiaoHua Wang <561399680@139.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH 6.1.y 6.6.y] netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting
Date: Wed,  2 Sep 2026 18:14:13 -0400
Message-ID: <20260902-daily-reply-0014-pipapo-fixes-tag-ack@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831194905.45045-1-kmehltretter@gmail.com>
References: <20260831194905.45045-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Fixes: a4983e89e3b1 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
> Fixes: 32bad10de347 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
>
> This two Fixes: tag do not make any sense to me.

> The two Fixes tags are for the two stable branches:
>
> - a4983e89e3b1 is the 6.1.y backport
> - 32bad10de347 is the 6.6.y backport
>
> I am not sure what the usual preference is here: one common patch with
> both Fixes tags, or separate patches for each tree. Which do you prefer?

Whatever Pablo prefers :)

-- 
Thanks,
Sasha
