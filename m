From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] patch-o-matic fixes
Date: Wed, 30 Apr 2003 23:49:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430214957.GA8011@alpha.home.local>
References: <20030430085332.GA32392@alpha.home.local> <20030430153222.GC685@sunbeam.de.gnumonks.org> <1051717921.8200.151.camel@tux.rsn.bth.se> <20030430162835.GA4546@alpha.home.local> <1051721066.8214.158.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Willy Tarreau <willy@w.ods.org>, Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051721066.8214.158.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Apr 30, 2003 at 06:44:26PM +0200, Martin Josefsson wrote:
> Please get a current patch-o-matic from cvs and try again.

I've just rechecked with a fresh 2.4.20 + patch-2.4.21-rc1 + cset-1.1141
from kernel.org, and a fresh p-o-m-20030429 from netfilter.org, and I can
only reproduce the problem if I don't enable 24_conntrack-nosysctl (as you
said). Once it's applied, tcp-window-tracking applies correctly. I don't
really know why I wasn't including it, because I had marked it as one to
avoid because of a conflict it would have caused in an earlier version, or
against a broken kernel... Strange...

> > 		pending/12_conntrack_nat_dependancy
> 
> This patch doesn't even exist in p-o-m anymore.

Yes, I know that but it's still listed here because I maintain a list of
patches to avoid, which makes frequent rebuilds far easier.

> > 		extra/ip_conntrack-timeouts
> 
> This one is incompatible with extra/tcp-window-tracking.patch
> 
> The dependencies in p-o-m won't allow you to try applying both these
> patches at the same time (unless you use force)

I know, but it's on my avoid-list too, because if I apply it by mistake,
I only see the conflict on the last one... tcp-window-tracking, so I
prefer drop it from the start.

Well, it seems that my list initiated to make my life easier fooled me
instead, this time !

Thanks for your help, Harald and Martin, and sorry for the noise.

Regards,
Willy
