Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95AED42
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 07:29:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rDRAW-0000il-L8; Wed, 13 Dec 2023 16:29:04 +0100
Date: Wed, 13 Dec 2023 16:29:04 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <20231213152904.GD27081@breakpoint.cc>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
 <ZXji-iRbse7yiGte@egarver-mac>
 <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
 <ZXm6zI16aVSwvEDB@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXm6zI16aVSwvEDB@egarver-mac>
User-Agent: Mutt/1.10.1 (2018-07-13)

Eric Garver <eric@garver.life> wrote:
> On Wed, Dec 13, 2023 at 01:13:54PM +0100, Phil Sutter wrote:
> > Hi,
> > 
> > On Tue, Dec 12, 2023 at 05:47:22PM -0500, Eric Garver wrote:
> > > I'm not concerned with optimizing for the crash case. We wouldn't be
> > > able to make any assumptions about the state of nftables. The only safe
> > > option is to flush and reload all the rules.
> > 
> > The problem with crashes is tables with owner flag set will vanish,
> > leaving the system without a firewall.
> 
> I'd rather see the daemon be automatically restarted. After a crash you
> still have a flush + re-apply on daemon restart. Avoiding the cleanup
> due to table owner flag only shortens the window.

But the filter rules are gone for a short time, leaving e.g. an
ipv6 network we're routing for wide open.

Same for any exposed containers or VMs.
So I'd say as-is the owner flag is harmful for filtering.

I'm fine with adding a flag that keeps the orphaned table around
and allows to (re)take ownership.
