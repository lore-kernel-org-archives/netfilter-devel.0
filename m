From: Patrick Schaaf <bof@bof.de>
Subject: Re: nf_conntrack & NAT
Date: Wed, 7 Dec 2005 10:41:49 +0100
Message-ID: <20051207094149.GA620@oknodo.bof.de>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<20051207070517.GA4361@rama.exocore.com>
	<20051207070039.GC474@oknodo.bof.de>
	<20051207130650.GA4151@rama.exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick Schaaf <bof@bof.de>,
	Herve Eychenne <rv@wallfire.org>, Jan Kasprzak <kas@fi.muni.cz>,
	netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <20051207130650.GA4151@rama.exocore.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

[SNIP]
> If we later need something different for IPv6, then let's do that at
> this later point.

Hey! That's absolutely fine with me. I don't care about v6 at all,
at the moment, and in the next few years.

But I couldn't let stand the opinion that stateless NAT would
be sufficient for what is now done with REDIRECT and v4.

BTW, my special application might well be the normal case for
a lot of nifty "captive portal" setups, e.g. at WLAN hotspots.

best regards
  Patrick
