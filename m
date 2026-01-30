Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970542EB87E;
	Fri, 30 Jan 2026 19:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769800156; cv=none; b=p8pK8Jw2iDmB8gJwf8R2P/R/IQnn+U3uys7I6rJ7pgF3X3qkAMKLRYbqKMu0/2hN2tkmIO21JXrau91ro1LFRW4RAztsOV1wwoI0bTrh1Ia83zug9Ye9Gf13k2iTZyyce556edy69GMgr54REFBcE6Lqd4TtrL253yBGtLi7WR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769800156; c=relaxed/simple;
	bh=rBhfQopWnftohEzB3BgoUhd1e9v5JvRwFWBMDnhJoH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ys4B6rxg9fxOuZuUbtEJNjzhVGWqAOmp3Cc54Esai4+FOzjaQpc+WUJU7LLn51kdE3IRH7Lrt0Z4Phu2WQopP28mVGfjPLxlTd5FksF7TW6844EKB3ENCUkwL6oKdXi/duuKID2rqHNIdJkpNGu5nn+zsJs8tMGiDMUAvdUJxQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F3EB6602AB; Fri, 30 Jan 2026 20:09:11 +0100 (CET)
Date: Fri, 30 Jan 2026 20:09:11 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH v2 net-next 0/7] netfilter: updates for net-next
Message-ID: <aX0B1xaFGL43xxUn@strlen.de>
References: <20260129105427.12494-1-fw@strlen.de>
 <20260130081245.6cacdde2@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130081245.6cacdde2@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 29 Jan 2026 11:54:20 +0100 Florian Westphal wrote:
> > v2: discard buggy nfqueue patch, no other changes.
> > 
> > The following patchset contains Netfilter updates for *net-next*:
> > 
> > Patches 1 to 4 add IP6IP6 tunneling acceleration to the flowtable
> > infrastructure.  Patch 5 extends test coverage for this.
> > From Lorenzo Bianconi.
> > 
> > Patch 6 removes a duplicated helper from xt_time extension, we can
> > use an existing helper for this, from Jinjie Ruan.
> > 
> > Patch 7 adds an rhashtable to nfnetink_queue to speed up out-of-order
> > verdict processing.  Before this list walk was required due to in-order
> > design assumption.
> 
> Hi Florian, some more KASAN today:
> 
> https://netdev-ctrl.bots.linux.dev/logs/vmksft/nf-dbg/results/496421/vm-crash-thr0-0

> [ 1144.170509][   T12] ==================================================================
> [ 1144.170759][   T12] BUG: KASAN: slab-use-after-free in idr_for_each+0x1c1/0x1f0
> [ 1144.170922][   T12] Read of size 8 at addr ff11000012a16a70 by task kworker/u16:0/12
> [ 1144.171079][   T12] 
> [ 1144.171133][   T12] CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.19.0-rc7-virtme #1 PREEMPT(full) 
> [ 1144.171137][   T12] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 1144.171139][   T12] Workqueue: netns cleanup_net
> [ 1144.171145][   T12] Call Trace:
> [ 1144.171147][   T12]  <TASK>
> [ 1144.171149][   T12]  dump_stack_lvl+0x6f/0xa0
> [ 1144.171154][   T12]  print_address_description.constprop.0+0x6e/0x300
> [ 1144.171159][   T12]  print_report+0xfc/0x1fb
> [ 1144.171161][   T12]  ? idr_for_each+0x1c1/0x1f0
> [ 1144.171163][   T12]  ? __virt_addr_valid+0x1da/0x430
> [ 1144.171167][   T12]  ? idr_for_each+0x1c1/0x1f0
> [ 1144.171168][   T12]  kasan_report+0xe8/0x120

Sigh.  Doesn't ring a bell, I will have a look.
