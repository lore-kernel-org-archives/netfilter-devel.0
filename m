From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] patch-o-matic fixes
Date: 30 Apr 2003 18:44:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051721066.8214.158.camel@tux.rsn.bth.se>
References: <20030430085332.GA32392@alpha.home.local>
	 <20030430153222.GC685@sunbeam.de.gnumonks.org>
	 <1051717921.8200.151.camel@tux.rsn.bth.se>
	 <20030430162835.GA4546@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20030430162835.GA4546@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-30 at 18:28, Willy Tarreau wrote:
> Hello Martin,
> 
> On Wed, Apr 30, 2003 at 05:52:01PM +0200, Martin Josefsson wrote:
>  
> > It does apply IF you've applied pending/24_conntrack-nosysctl.patch
> > Which should have been done. We've had implicit dependencies on
> > submitted and pending stuff many times.
> 
> That's not my case, I disabled 24_conntrack-nosysctl because of the dependancy.
> Unless I have a broken tree, or a conflict is induced by other patches,
> I'm certain that tcp_window_tracking on top of 2.4.21-bk doesn't apply
> cleanly. Here's what I have (in fact, what 'runme' sees) :

Please get a current patch-o-matic from cvs and try again.

> And those I exclude because of too complicated rejects, or incompatibilities :
> 
> 		pending/12_conntrack_nat_dependancy

This patch doesn't even exist in p-o-m anymore.

> 		extra/ip_conntrack-timeouts

This one is incompatible with extra/tcp-window-tracking.patch

The dependencies in p-o-m won't allow you to try applying both these
patches at the same time (unless you use force)

-- 
/Martin
