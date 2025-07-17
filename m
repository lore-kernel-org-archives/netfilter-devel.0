Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7201C2E8E0B;
	Thu, 17 Jul 2025 13:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752759107; cv=none; b=glvA52Lgd3kqAReccGUs/GYif0NQ2w0s8EssUyDdz83QlJITB2ixa1dOv5rSmdjkK4zgPRKWtVst8abXxfFRCwRDbIWOU/yF5mICjctn7S0Di/+cfeybyVOhEBHGhPonMEHTK6x9JKNKn8ZE18tBz9A3FhV1+Xew+GnihSeSw5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752759107; c=relaxed/simple;
	bh=WvnZljD9LfE/4t4NQ5QtpY/tagREIet7i/+Hj9YA1r4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLPEyEeUTlAKnFvo2qnJYzS/3V7YAWIGxcFtnGe+i0X1a2xrz89bM986wRp4kTu0p+un2C/6AU09VXA7aPsj08atF7YDNpJSTAHX/wiFLHRyzmmoIY/vANrW8eSZ72VSTEQvHpJwkEkIPKzmE5/Z5OpbbYhUugWyOuw57apfg6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bk0TDF8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bk0TDF8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EE6C4CEEB;
	Thu, 17 Jul 2025 13:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752759105;
	bh=WvnZljD9LfE/4t4NQ5QtpY/tagREIet7i/+Hj9YA1r4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Bk0TDF8O2HqcR3XYji7ZN45eXoESOYckuH/BK/qlMue+WupEQ6UahEUix/ZbLUDw0
	 NhwA2cLMKFiGA2/wXvtqGT2oFdxdYeppmkt0izZRVrtUBvvr37wLtpuRDhz9Awd0I4
	 3DeZuiQB0FVVNWYrV3TUAM5S5Kj4OG1SmGlAKsDDccrHQxYYwUWv0+nSuY8DI85JR8
	 bGFVvfyNEBNR8Jil0UTS1rzvJXPUITcJQo5Z1QaA6R8lU4sJPfrqLsRq0t93QbqLIr
	 WKh45Tb+h9O1fzjekW2Rpxrri26xYPA0Wsye2SO+V1IbrYF8yjmmMOtprh1wu/rUe6
	 4xu0ilcuzYonw==
Date: Thu, 17 Jul 2025 06:31:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 horms@kernel.org
Subject: Re: [PATCH net,v2 0/7] Netfilter fixes for net
Message-ID: <20250717063144.598f0c98@kernel.org>
In-Reply-To: <20250717062338.18ed7f69@kernel.org>
References: <20250717095808.41725-1-pablo@netfilter.org>
	<33ce1182-00fa-4255-b51c-d4dc927071bc@redhat.com>
	<aHj0QSJkzexEKE2T@strlen.de>
	<20250717062338.18ed7f69@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Jul 2025 06:23:38 -0700 Jakub Kicinski wrote:
> On Thu, 17 Jul 2025 15:01:53 +0200 Florian Westphal wrote:
> > Paolo Abeni <pabeni@redhat.com> wrote:  
> > > # timeout set to 1800
> > > # selftests: net/netfilter: conntrack_clash.sh
> > > # got 128 of 128 replies
> > > # timed out while waiting for reply from thread
> > > # got 127 of 128 replies
> > > # FAIL: did not receive expected number of replies for 10.0.1.99:22111
> > > # FAIL: clash resolution test for 10.0.1.99:22111 on attempt 2
> > > # got 128 of 128 replies
> > > # timed out while waiting for reply from thread
> > > # got 0 of 128 replies
> > > # FAIL: did not receive expected number of replies for 127.0.0.1:9001
> > > # FAIL: clash resolution test for 127.0.0.1:9001 on attempt 2
> > > # SKIP: Clash resolution did not trigger
> > > not ok 1 selftests: net/netfilter: conntrack_clash.sh # exit=1
> > > I think the above should not block the PR, but please have a look.    
> > 
> > No idea whats happening, I get 100/100 ok :-/
> > 
> > I'll send a revert or $ksft_skip for now if I can't figure it out.  
> 
> Oh, I see this disembodied thread now, sorry.
> 
> No need to send the skip, we can ignore the case when ingesting results.

FWIW

# nft --version
nftables v1.1.3 (Commodore Bullmoose #4)

nftables# git log -1 --format=reference 
610089f2 (cache: Tolerate object deserialization failures, 2025-05-16)
