Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E64175A9C;
	Fri, 10 Apr 2026 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775824645; cv=none; b=uxg1G5M/TS8xuJh9Kw6YOstuBbYjW7Hni1fPGCbArQ1EzrbTZuuLpMSF0Cg/byEsIwZrfn1KmqQAhEqOIudLQ+lLD3B928Guvk5m66tVMA3FEw3z2x5tPl15l7fcUW130PSDBewvTRfFB9jBYbpu0EtNFKgyyxGPbrclBHis2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775824645; c=relaxed/simple;
	bh=wkqkcVxmZ2uKiOxR7eiu0tIr4+iX8LqTb5bke0QKe4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crjJgjpqP7NdFhPh7qTDFGUbJQr4uI9Bno2ClllElA0jWbMTF43gy71npRPo5ZdeFFNI2FRpHSRz3voY5CrUHQ2kAsui+81XlG8G7Qtm42NfwwMPAhG8NbN7x7TUR8jaV1/QfKGKnOyBkhJ69oCZ6cL71YkIC7wVT104NBYJjHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rI7NAcx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rI7NAcx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019B4C19421;
	Fri, 10 Apr 2026 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775824645;
	bh=wkqkcVxmZ2uKiOxR7eiu0tIr4+iX8LqTb5bke0QKe4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rI7NAcx0hsLrLhwwvejqPOI14FViYvZTMJx6ipRhVPrUA29EuuuFgJ0UCeL5pgG5w
	 vWKp+ElmoGwTkUQAcywZME4SSUXQQvw5ZAYb4S5bzO6vXEBNYWhBa6OiRPPuLstooi
	 HbzGVcDlW1WOBJ6By5LWceYYAzkoCP2Dq0ygtkn0qiNEskoVJXNjHd0AwxgN/Dc3Jb
	 EA6C7gG/+/DqxAlL4EWqCAiHkR3pg6E6imDHGxBIktBwOG2ayVVb4PLZrZzB5xZQFi
	 m8a9QjEvZlJTMgUnePEim6pGO5dw1B7wgyN9VAF/pDDDKLLYqe1z4b4+GYQAevPhZw
	 r9gbUXP843UFg==
Date: Fri, 10 Apr 2026 14:37:22 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch V2 07/11] alarmtimer: Convert posix timer functions to
 alarm_start_timer()
Message-ID: <adjvAgaEw0hKWNTs@localhost.localdomain>
References: <20260408102356.783133335@kernel.org>
 <20260408114952.400451460@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260408114952.400451460@kernel.org>

Le Wed, Apr 08, 2026 at 01:54:16PM +0200, Thomas Gleixner a écrit :
> Use the new alarm_start_timer() for arming and rearming posix interval
> timers and for clock_nanosleep() so that already expired timers do not go
> through the full timer interrupt cycle.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Acked-by: John Stultz <jstultz@google.com>
> Cc: Stephen Boyd <sboyd@kernel.org>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
