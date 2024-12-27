Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ACE433D9;
	Fri, 27 Dec 2024 19:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735327386; cv=none; b=NY59rrkSumq9gxGtn4NZGy8ILs0voimfpaVTLpnB9qOUojm44VwafZmZ8e6HoSmHPgvDgtPF4Ligaqpa3YTNodkC1X4fw9Om0Ftd7AOUk+ALzMgTINZZfy8i+/UZN89SxaqfP2TA8S8hWcfk4bxh++vo8o19SADVCJ1ipeuUhPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735327386; c=relaxed/simple;
	bh=TB3R6A9GdrG0tsGUXNH7POvpBtw6uAWDlM4LOyZuXzc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/mYS7P2a4eiiLO/smKJai9FHSbd9cxKajlyMxRR7JIS+AdzdpIQ4JlZWUWuMRwd9R836AMbZkxYPjOL381PyjBzk7Dg1U2f54M0f6zBt3EjwGIb02FR93yJagEUACLiEEVvB4I/BGQffWci8uN3+FZs8bXnbOeu7Wg3TBXO8HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJHJKmnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJHJKmnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F408EC4CED0;
	Fri, 27 Dec 2024 19:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735327386;
	bh=TB3R6A9GdrG0tsGUXNH7POvpBtw6uAWDlM4LOyZuXzc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MJHJKmncdPY3+hC7Qx1VCE4cFi5wzpCNFSy7waCbsN98GTl+FW0BE104zPKV0C7Rv
	 d/rnNeiAHMtiRMYgEVqBhHonsUkvKxfIICXMkH2dXtqWttO2kem7toK+NQnq2N0sZA
	 epVAkUAdA48sM48NmlZytTrbmyBPPk+9gX8fGhkyPu8qibKX2cv9Ldna0/bv9Vw5Ge
	 xsK7mJT3cQBVHcrCM/G3GjTj2XFp0xnWpAzISwON5ke02+5Y9Zkoc5HC4/ktwI6RGY
	 LaYdNCznfkxCSp7ayV4mQiA+PIHxeTslD772mNHqmaLPGpIvkd6okn6h4r5Gz9IaIr
	 qO5O6ocmh5CpA==
Date: Fri, 27 Dec 2024 11:23:04 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
 edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com,
 joel.granados@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org,
 pablo@netfilter.org, kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, shenjian15@huawei.com, salil.mehta@huawei.com,
 shaojijie@huawei.com, saeedm@nvidia.com, tariqt@nvidia.com, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 virtualization@lists.linux.dev, ij@kernel.org, ncardwell@google.com,
 koen.de_schepper@nokia-bell-labs.com, g.white@cablelabs.com,
 ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com,
 cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com,
 vidhi_goel@apple.com
Subject: Re: [PATCH v6 net-next 00/14] AccECN protocol preparation patch
 series
Message-ID: <20241227112304.0c1a7b1b@kernel.org>
In-Reply-To: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Dec 2024 20:11:57 +0100 chia-yu.chang@nokia-bell-labs.com
wrote:
> Hello

Hello.

Someone may still review, but:

## Form letter - winter-break

Networking development is suspended for winter holidays, until Jan 2nd.
We are currently accepting bug fixes only, see the announcements at:

https://lore.kernel.org/20241211164022.6a075d3a@kernel.org
https://lore.kernel.org/20241220182851.7acb6416@kernel.org

RFC patches sent for review only are welcome at any time.
-- 
pw-bot: defer
pv-bot: closed
