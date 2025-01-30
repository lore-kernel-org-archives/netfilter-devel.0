Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8C2C8FE;
	Thu, 30 Jan 2025 01:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738198859; cv=none; b=QKBx9lHLUrlwmNihj1FudpaRR0a1PMY5pOWu+Yrj0VylFDRk6wiQ/gLnfWJJQ1kzdGdUpC6sXXNc75AGC7vQmcDbeQ0qvws5iuXoADMPDhOVXsegyckvmFPXe1kdrqgDFhAv/bxonS0ELMIWfiw/gNxfF4Rit8PPt4Z/+sDOvII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738198859; c=relaxed/simple;
	bh=/B+JDZnEPBEY4JtpS/yo0QnKZC74bI/QnPSHlEUQ42o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ae48fvXAxAEa4wqXyOD9DWbIzb7jDkchcmyqQTV1zJAWIoSPglWD7CwCHbdiWa1JQHA6hroYjru6D8tLLzzUqIOx8Qt0N5oJvRFozzCpfhEyIC/KThoSRx9u5Z3xUTRnZOQZAYNE6gtvEl/BL0u7sjsNJ3766OuqJMnXb5IPdgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tqOw4eYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tqOw4eYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0471C4CED1;
	Thu, 30 Jan 2025 01:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738198858;
	bh=/B+JDZnEPBEY4JtpS/yo0QnKZC74bI/QnPSHlEUQ42o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tqOw4eYeC2iK+0Zs+XfznXT4B+QMe/7vVFntB+GvliiUBAFjevy3NHb1D3CTsaYpV
	 5zJLqtJ2SdLTRf4psI/txbhpR+2JGZ4iRTxtVRRMD9YcswOXRtAisp3B3FdvuqnAu0
	 13yYcg5G/cc+5xcQtBNx9I7n6p9X0dsCB4cwx/G3gnkgo4vOu5OUlgmqoeRy+CkWJK
	 jM1C6KB7rOqdA7D2N64dT8qI1gq252E6CFVxBQI2rRp2MFbQ1hj+imAndNdFcySrhT
	 +6fP3eBKSrZv6C0Y28sNPl8eIkA/zI4WwHNcbPS7/DwlAxKDPkcx+BK3D44sPv2v7V
	 KTsAax/7zTk3w==
Date: Wed, 29 Jan 2025 17:00:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [TEST] nft-flowtable-sh flaking after pulling first chunk of
 the merge window
Message-ID: <20250129170057.77738677@kernel.org>
In-Reply-To: <Z5oPNA0IFd7-zBts@calendula>
References: <20250123080444.4d92030c@kernel.org>
	<Z5oPNA0IFd7-zBts@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jan 2025 12:21:24 +0100 Pablo Neira Ayuso wrote:
> > Could be very bad luck but after we fast forwarded net-next yesterday
> > we have 3 failures in less than 24h in nft_flowtabl.sh:
> > 
> > https://netdev.bots.linux.dev/contest.html?test=nft-flowtable-sh
> > 
> > # FAIL: flow offload for ns1/ns2 with masquerade and pmtu discovery : original counter  2113852 exceeds expected value 2097152, reply counter  60
> > https://netdev-3.bots.linux.dev/vmksft-nf/results/960740/11-nft-flowtable-sh/stdout
> > 
> > # FAIL: flow offload for ns1/ns2 with masquerade and pmtu discovery : original counter  3530493 exceeds expected value 3478585, reply counter  60
> > https://netdev-3.bots.linux.dev/vmksft-nf/results/960022/10-nft-flowtable-sh/stdout  
> 
> this is reporting a flow in forward chain going over the size of the
> file, this is a flow that is not follow flowtable path.
> 
> > # FAIL: dscp counters do not match, expected dscp3 and dscp0 > 0 but got  1431 , 0 
> > https://netdev-3.bots.linux.dev/vmksft-nf/results/960740/11-nft-flowtable-sh-retry/stdout  
> 
> this is reporting that occasionally a flow does not follow flowtable
> path, dscp3 gets bumped from the forward chain.
> 
> I can rarely see this last dscp tests FAIL when running this test in a
> loop here.
> 
> Just a follow up, I am still diagnosing.

Thanks for the update!

FWIW we hit 4 more flakes since I reported it to you last week
(first link from previous message will take you to them).
All four in dscp_fwd
