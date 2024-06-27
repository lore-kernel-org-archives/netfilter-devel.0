Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EB02139AC;
	Thu, 27 Jun 2024 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719513124; cv=none; b=GH9Y7hs+A+qgkiN+nwLJ4Sn+hUL9iHw9UyhCvHWo+Ow2E/W9YFHRQ1PXodaqVp6I/EqvW6u+LO8EEwXHdpsoLccv8+siBy4DInBLZ+aIp/T7Ww6iqwza4cPPIT3IO72ue4OI2ZqrUDVn0EDs6vpV7LSWp5UVUIXVV5+6SXD+0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719513124; c=relaxed/simple;
	bh=myq23XvtFYMTcpZAas2epfkOcueDKf4N7eT75FURyYo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DMgBOZJla1xe6BV5fvpb/SYP2tF7YCsIKXeCtwuRdprsYINFeHDqtACos7TSYlZGExEZxY0TDSQSxfMIkaaCvtBphLpU8h82SBiW7P5UH2LubYTAkvuvwPW/RLct9MsCZMdCroMEiMPOTPV7ZHBpgqDox7AFdCP66INrUgZKM8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FD4oXTO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FD4oXTO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AC1C2BBFC;
	Thu, 27 Jun 2024 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719513124;
	bh=myq23XvtFYMTcpZAas2epfkOcueDKf4N7eT75FURyYo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FD4oXTO3fU8U5D+MelXA2NJzF1mP9Bfu9Su2BRA9hbQYOLcuBC4fEguF6ySv4vS+K
	 OZZ5XbAZjQGQ0mt9Rh8o+W8AJb5xhRCAYTmZyet2t4WTFVO324qipy+DqjWkdJjPWu
	 A3omBFR/S2W9ip6lWav18Fdy/X+tKui3C/zIx+miiJmV+MgDUH1Oz2SVsZxKW8UiTp
	 d8/ske4OJ14bcbrILC837yYcg88X9YD2B6ZxEaK4Ats7VCN86BWytCXZGS9xyTtxZZ
	 O+Q11WVO5TWb5AO0nN0kW/nczYBDyTq50HhPuaFCnI0BaQYDjfqZ3Lui/kOcIOJpJ2
	 a3peJ3QdVPc7w==
Date: Thu, 27 Jun 2024 11:32:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de
Subject: Re: [PATCH nf-next 00/19] Netfilter/IPVS updates for net-next
Message-ID: <20240627113202.72569175@kernel.org>
In-Reply-To: <Zn1M890ZdC1WRekQ@calendula>
References: <20240627112713.4846-1-pablo@netfilter.org>
	<Zn1M890ZdC1WRekQ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Jun 2024 13:28:51 +0200 Pablo Neira Ayuso wrote:
> Note for netdev maintainer: This PR is actually targeted at *net-next*.
> 
> Please, let me know if you prefer I resubmit.

Not a big deal, but since you offered I have another ask - looks like
this series makes the nf_queue test time out in our infra.

https://netdev.bots.linux.dev/contest.html?test=nft-queue-sh

Could you take a look before you respin? It used to take 24 sec,
not it times out after 224 sec..
