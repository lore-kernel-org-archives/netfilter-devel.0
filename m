Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F87631A072;
	Sat, 31 Jan 2026 01:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769821286; cv=none; b=giy0s7a2c9hMymFv9aT2/9lvHKTwDUoCTISPMBv1+SpnCOy3Uaw7vbm1JCAcOXOBK7Z90UazBhyxBiRtDA0uQZlgyB6gY4E/oaEuNpFmd4Z+ATnrkb4rmn/BXyUamaq3YymrJUup5d8sX3aLEydGO2VcFmSZ2NhTGkhspFj27vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769821286; c=relaxed/simple;
	bh=6jUU2WMZWgs13TE3jzFTfzLrQ+5BR4bjxhLtIpfjGHI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAe5kMLPa1jAeCLN1u6OiDj3jXZrRMGhpvqHg5MDP80CHOZ82J37BqZFizgIV5z9RLma+GI3d4aPbuhZ67ljwYwsnJMjjMMWu6srJ3nyAY9L6HfkxYwmYhGzKiE05k6oyT3ZulqX0RlOByjckE0DZ1796oumHCmHS9YhuU4+FNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTTcVysP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTTcVysP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4C4C4CEF7;
	Sat, 31 Jan 2026 01:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769821286;
	bh=6jUU2WMZWgs13TE3jzFTfzLrQ+5BR4bjxhLtIpfjGHI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cTTcVysPiwIxKymJlop9+c0VRxcooNoqnykk5cY7EMQMdgpe8t4KNJUp7ohxqDfUp
	 6PzduuCNZaMZnhCh8qFEn0FcUhZGWEpwB8XOLd35EtIxupA0JB+2qFwZtDpSX9Auhi
	 J1KoatKZ00jf8nl7wyoZHzaqMwIZ3/uoBfmvFJI4kiF19IcBIKxisq6iqynfjIk+zL
	 BeRME9lqtpSzkhraxqqjSMIUUPjY8KF/jkvBT5KiDvk2FJ4Kuwas6I6NzR+pFF0nWO
	 XXHxQIlDSzMBr6rM7ScbExT2nWkX1FkQAwvKqXOY+6blqDY5/fWg7uXeZU7t6mJrOZ
	 W/lfPNLqUxr2A==
Date: Fri, 30 Jan 2026 17:01:24 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 net-next 0/7] netfilter: updates for net-next
Message-ID: <20260130170124.5cfc277b@kernel.org>
In-Reply-To: <CANn89iKUV07+84PVq0cHe3vMaSGNTQzhq9=xetg+_P2DmsPmQQ@mail.gmail.com>
References: <20260129105427.12494-1-fw@strlen.de>
	<20260130081245.6cacdde2@kernel.org>
	<aX0B1xaFGL43xxUn@strlen.de>
	<CANn89iKUV07+84PVq0cHe3vMaSGNTQzhq9=xetg+_P2DmsPmQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 30 Jan 2026 21:23:23 +0100 Eric Dumazet wrote:
> > Sigh.  Doesn't ring a bell, I will have a look.  
> 
> Could this be related to "netns: optimize netns cleaning by batching
> unhash_nsid calls" ?

Ah yes, that makes more sense. Thanks!
