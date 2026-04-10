Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E907533D4FB;
	Fri, 10 Apr 2026 21:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775854938; cv=none; b=XODcgYs5D3j/k28qwgrhp4WDdOuFuGxA3zcg0N+E1Lb562PVQ2H/Y06p1RLgLsjrp0IarmMOO/qeo8SaxIv3eb76YoZNsCma1dkgSV9SRY+hYyLSVwpWUjse2R6FVTBCJUu13xk2c/T0UlGGLaVlPdL/1Bc1LaW6xV5FIYiQj+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775854938; c=relaxed/simple;
	bh=NebN3Wxx3EkDVXNhorgAZBBDdQeK7iIH/y0vHwzj9Oc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gYQFqCy/l5K6aShuontPWISBkaFZh2PgZWAHU7Jb8T7N3bb44mVCsvI+MrvJnou1wDp7CkqYb0rmZ6non8jr42GE6BOLbpCtZvXU36Kb+LZzUTBsHjb2d/DRhn8NONJuZS102UM9yWSvnBmg0ctugmWfM49GAsXtX6WF4L+E0QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeoN5wlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeoN5wlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ACCC19421;
	Fri, 10 Apr 2026 21:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775854937;
	bh=NebN3Wxx3EkDVXNhorgAZBBDdQeK7iIH/y0vHwzj9Oc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XeoN5wlCW42zNPVn1fPVthkRRoraLHnYocRifeTqIdAYIAyxH4QXSJi6oanAJ4fjT
	 VaDEbWQKEuIZHoGKXlWknwuem2NTfBhhq7C2FOmhP8EEd+otnyzMWMEBgUJYzB2OjK
	 InDvmdp2mfRRbw08h1lEoNH+G7PJJtmlfBdPH6TlfI+4s+UP8yrXbAVJ9ufWidLcho
	 ujtCcO0XusveIPX2RzI8dmBE4QngzbueBungtdvFDMQQFwhQS79pSfO4LqL+Ugomzh
	 5tp/HhSwKVO7vTm1pX74h6STU2jQp2drJK+xlkfSmyAdoadaHFCxKJlrbofsLv3lTI
	 8k9yqcdHTKosg==
From: Thomas Gleixner <tglx@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>, Stephen
 Boyd <sboyd@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
In-Reply-To: <20260410205203.GA3922321@ax162>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org> <20260410205203.GA3922321@ax162>
Date: Fri, 10 Apr 2026 23:02:13 +0200
Message-ID: <87fr52zfze.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Apr 10 2026 at 13:52, Nathan Chancellor wrote:
>> Link: https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/
>
> This change in -next as commit 1c2eabb8805d ("clockevents: Prevent timer
> interrupt starvation") appears to make one of my test machines
> consistently lock up on boot (at least I never get to userspace). Most
> of the time I get stall messages such as

Can you please retest the changes I just pushed out into:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/urgent
    
namely: d6e152d905bd ("clockevents: Prevent timer interrupt starvation")

Thanks,

        tglx
