Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4913DCDBB;
	Tue, 14 Apr 2026 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776176852; cv=none; b=iLrDEUTXoPOlMLKwNWywb+R3RrhG7mYJZmGXGhTXGmrN8fRpeyqmzofn7ovvSENpMO5k0eG7OIVGIWYZmzo7eNh6gutm6CsgqDqbL9QBNHMbOs8eqfRtvAPCj+zW4AL2W5qF/B/LyWY5kd9GnzOo/zfaf6mPHbkTRjMFodrGcGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776176852; c=relaxed/simple;
	bh=i4xJrdkZCNvCqgwxr9JrQ53AyB8oPiIGtsM7/BoZH/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGSCZGFbVIGL9vPNsHzTtIvKcPeBehoyw9IMEiDHa2+XkDnp1GVUHagCbOTFDxTFFt60qD8XtW5ayavncnTBctuaJYWsujJOyfKoE/0vztpIcaiRGUTc0b5J5ETk1biWUfyUIo9tSPOMQvg2QJEXisIEEtgsh2ruNUbMw24Usck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdvjplzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdvjplzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45911C19425;
	Tue, 14 Apr 2026 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176851;
	bh=i4xJrdkZCNvCqgwxr9JrQ53AyB8oPiIGtsM7/BoZH/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cdvjplzhW57JqjM5J9cfK4l+AJSCFCpMNxIk4cDg6he8jr/pL5Z7ocEussyMGTUoE
	 jqL46ln4lm6K/uvTL4g44YaQBidTTMXp7KdHNVJGyyuCkU3QZ8TkWxQdMDXGe+AgQe
	 KTSagB/eI/SPWcBioiBR92vVXLhxjvkV86p7Xb3lctjeQoPZ4JpD+7NM6nBvyUXh9J
	 ptR2UPd6P/WtF37a7t7TE0qCaJcnVzHMpjuAFK5kUJMWoBHyJ+Ku/Ry89cW7HOa+XH
	 jvl/zErZaYA9fuJ7L1BkHiWLdKsFtiufkQmyDtAWZBSSbqyeIOE0lEnrhgtigkYbnB
	 RSLk+blN1aPmg==
Date: Tue, 14 Apr 2026 16:27:29 +0200
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
Subject: Re: [patch V2 11/11] alarmtimer: Remove unused interfaces
Message-ID: <ad5O0RO82sKUeBFt@localhost.localdomain>
References: <20260408102356.783133335@kernel.org>
 <20260408114952.670899355@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260408114952.670899355@kernel.org>

Le Wed, Apr 08, 2026 at 01:54:33PM +0200, Thomas Gleixner a écrit :
> All alarmtimer users are converted to alarm_start_timer(). Remove the now
> unused interfaces.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Stephen Boyd <sboyd@kernel.org>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
