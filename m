Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF6F45BE4;
	Thu, 27 Jun 2024 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518668; cv=none; b=U37XuoQAbbAyb1VoFoB0IsGin7t/mzJmqItfYfY7jpRxCJkC6ZzvH2vic5g+dRfhWNa5agIOh1grTfWDhNtP4lNjRrv5fultIuUVJOx/0KVMMsB01npiZdUiUtruiVaVLxZuqpSbLWmh79+Z2fLNz/qDKkvUiQE2UqZ+XVdhyj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518668; c=relaxed/simple;
	bh=CTOleaIq2SpthvaUvX+TbarpxX5f4lmcv5LDZDhUtxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/eWr+RUAtGF6u/u9sVADS0FCk+GlVEMJ6qwUJaK5v0doHFZHuuSfoajWBMUNgchWqIX6rDNok4zZJJhVA0Q0nPqilkmZxKcWaPXKFIgy/8v4MBlX8T1OyAfulrEszg3xYIGq8kQLmnvz1g7UQdK3aLnnrKHpLO31X4HNFX9IcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5AEe5E8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5AEe5E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB7FC2BBFC;
	Thu, 27 Jun 2024 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719518667;
	bh=CTOleaIq2SpthvaUvX+TbarpxX5f4lmcv5LDZDhUtxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c5AEe5E8AT/AZPXXMWCSNp3xZp1ZyjOngzXrlCToFw3PAs0l2vAa957o6lyo0sZ6x
	 AQpboLnwGIqkeGsGFxPNmXjlxSznIgR9Nn5axx47bsbf09kEAzZSZMVJU9JLtywnKV
	 S84cYorKnNO1Ek//VxHv5CExehftf8RTYpY3p4tdYkKJU3ieh57IC72c5R3PmiIYEF
	 vu0u1S93dDN+L2Bl3LzNZp/SpA3AeJ6U8mPvxdZqQegblhrVvc6JcaJZgqJSR1b0ny
	 yZ/8yFDizH71cazV89rMEerEUUGQRnk81XH5yVm1/HHFTZujC+7RsuODi2DUiYUhkz
	 xklkXtelZTwXw==
Date: Thu, 27 Jun 2024 16:04:25 -0400
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, kuntal.nayak@broadcom.com,
	stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH -stable,6.1.x] netfilter: nf_tables: use timestamp to
 check for set element timeout
Message-ID: <Zn3FyYTUl267N1t_@sashalap>
References: <20240626235314.281432-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240626235314.281432-1-pablo@netfilter.org>

On Thu, Jun 27, 2024 at 01:53:13AM +0200, Pablo Neira Ayuso wrote:
>commit 7395dfacfff65e9938ac0889dafa1ab01e987d15 upstream
>
>Add a timestamp field at the beginning of the transaction, store it
>in the nftables per-netns area.
>
>Update set backend .insert, .deactivate and sync gc path to use the
>timestamp, this avoids that an element expires while control plane
>transaction is still unfinished.
>
>.lookup and .update, which are used from packet path, still use the
>current time to check if the element has expired. And .get path and dump
>also since this runs lockless under rcu read size lock. Then, there is
>async gc which also needs to check the current time since it runs
>asynchronously from a workqueue.
>
>Fixes: c3e1b005ed1c ("netfilter: nf_tables: add set element timeout support")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
>This is a backport for 6.1.x, please apply.

Queued up, thanks!

-- 
Thanks,
Sasha
