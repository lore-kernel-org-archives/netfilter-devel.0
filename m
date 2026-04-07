Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAB33939C9;
	Tue,  7 Apr 2026 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775585024; cv=none; b=Ad/OviOsiuor+Asw8u2b7ChFdD1SxUmLovjnv8aPJB5+l/wq3QxBXWqSh0ed7/reeCCrRYwtbQMLw3ZzQ00H/Cl05vr51a4Q41q+AKFQx4SIlpNI4vQt4oG+x0wxJ7mgCTqT89wFWrJ2kPaDlbO2PdkwRH9c6TXO4u5H8Hpry54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775585024; c=relaxed/simple;
	bh=PCVX5+MJaDtv/5QhBK4sEVcRXCI5vHo43oyqAw9jfPE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Falfi8LjMtAq/4ZyVVggPrPtOzk6jVLakMf1JPKWnLcffE/5xPgU4WbLKWCrLZb820OG1kde5aoardJQaSJh+LK+Z2hKTbwbJL5YKymjlClGT+HZbIiasm+1vRnvwWlgt7ttwrBSzQVsBwSIfWUc9hOhuNyuYVXJ4rLBbAZ3xnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCAvlZFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCAvlZFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B267C19424;
	Tue,  7 Apr 2026 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775585024;
	bh=PCVX5+MJaDtv/5QhBK4sEVcRXCI5vHo43oyqAw9jfPE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JCAvlZFCbL40yalBtx+vibMzq1gI0LuOkr9zf7wT+0s9dpq0I4d5U9ZHv4rMIwoN/
	 lOaHUp7VLggxIpmS3tjRVqJxdTCHT7rw1f0JrPRceWOXpDY8EM9v44cuLv65/1ZW6s
	 wsBIDGdekvhUlGZneUCm68A+jviQj0jkKZJRzTh2WpKWFeO1dSoqZwi3oei5FT3Q14
	 fcBg7ZQvEIfp0pfxLyM5NSyW2jQpLeq+NJwYCvB1rRtY1Jo0fDYfYtWd4ppviFmmkx
	 KeBRgqZ3zbApsODuNYkbgy7xUAYpumLGGcWLLfZjLoeNTTDtxOzy/yX6OAHzAlkRAI
	 LNHJidhDWpG+w==
From: Thomas Gleixner <tglx@kernel.org>
To: Calvin Owens <calvin@wbinvd.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 00/12] hrtimers: Prevent hrtimer interrupt starvation
In-Reply-To: <adVA_uv1srA_bsKj@mozart.vkv.me>
References: <20260407083219.478203185@kernel.org>
 <adVA_uv1srA_bsKj@mozart.vkv.me>
Date: Tue, 07 Apr 2026 20:03:40 +0200
Message-ID: <87ika24phf.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 07 2026 at 10:38, Calvin Owens wrote:
> On Tuesday 04/07 at 10:54 +0200, Thomas Gleixner wrote:
>> He provided a reproducer, which sets up a timerfd based timer and then
>> rearms it in a loop with an absolute expiry time of 1ns.
>
> The original AMD machines survive the reproducer with this series.
>
> Tested-by: Calvin Owens <calvin@wbinvd.org>
>
> I'm happy to test subsets of it and stable backports too, if that's
> helpful, just let me know.

We'll only backport the first patch, so confirming that it still
prevents the issue would be nice. The rest is slated for upstream only.

Thanks,

        tglx
