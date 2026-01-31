Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD5036C5A2;
	Sat, 31 Jan 2026 21:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769893214; cv=none; b=Bl6Q+cyqvPHUfRYaqqNPTQY2WdYaWjapE/ZF5enkzjG4vLMJsWarenf9Ow0lNthkNI3PaiUik/uiwdxjKTfcIdI13+QCNe34CsxlzBTaLz7qp5ipytsTKVdtlbz3hgYNUmelEku3gyh7NSU/NPtuxIlGUKn1GHIimMdvgrbi80g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769893214; c=relaxed/simple;
	bh=+oxbG0yy9swBgtz/1bCOAwZzhbzAHF4ojzsXTULOXak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5yg9H9g1/UtpY/y7BVGNimk6LOAWQTfh9uJXR7UrSpuFL2s4OPizqY3qdmX9VVmqyk0diGZGeS/c8nfdDxK1QcpSJk5qGvCQVxSeKIdfI8W2lphD9hJDLD5ssefoN+OpwINSacOZ0UTiahIyCbanDMI4CZPspXUYIXxhH8onAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5DC4C60186; Sat, 31 Jan 2026 22:00:04 +0100 (CET)
Date: Sat, 31 Jan 2026 22:00:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 net-next 0/7] netfilter: updates for net-next
Message-ID: <aX5tQtxzcYzbYW6o@strlen.de>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKUV07+84PVq0cHe3vMaSGNTQzhq9=xetg+_P2DmsPmQQ@mail.gmail.com>

Eric Dumazet <edumazet@google.com> wrote:
> > > Hi Florian, some more KASAN today:
> > >
> > > https://netdev-ctrl.bots.linux.dev/logs/vmksft/nf-dbg/results/496421/vm-crash-thr0-0
> >
> > > [ 1144.170509][   T12] ==================================================================
> > > [ 1144.170759][   T12] BUG: KASAN: slab-use-after-free in idr_for_each+0x1c1/0x1f0
> > > [ 1144.170922][   T12] Read of size 8 at addr ff11000012a16a70 by task kworker/u16:0/12
> > > [ 1144.171079][   T12]
> > > [ 1144.171133][   T12] CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.19.0-rc7-virtme #1 PREEMPT(full)
> > > [ 1144.171137][   T12] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > > [ 1144.171139][   T12] Workqueue: netns cleanup_net
> > > [ 1144.171145][   T12] Call Trace:
> > > [ 1144.171147][   T12]  <TASK>
> > > [ 1144.171149][   T12]  dump_stack_lvl+0x6f/0xa0
> > > [ 1144.171154][   T12]  print_address_description.constprop.0+0x6e/0x300
> > > [ 1144.171159][   T12]  print_report+0xfc/0x1fb
> > > [ 1144.171161][   T12]  ? idr_for_each+0x1c1/0x1f0
> > > [ 1144.171163][   T12]  ? __virt_addr_valid+0x1da/0x430
> > > [ 1144.171167][   T12]  ? idr_for_each+0x1c1/0x1f0
> > > [ 1144.171168][   T12]  kasan_report+0xe8/0x120
> >
> > Sigh.  Doesn't ring a bell, I will have a look.
> 
> Could this be related to "netns: optimize netns cleaning by batching
> unhash_nsid calls" ?

Thanks Eric, that seems plausible.

Did not yet have much luck with reproducing this so far, I will
look at this in more detail lon monday.
