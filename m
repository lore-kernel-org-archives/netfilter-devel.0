From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 16:40:49 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15644.45834.373409.220647@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 28, 2002 at 12:03:38PM -0700, Don Cohen wrote:
> Patrick Schaaf writes:
>  > I have real data from an IRC server (one of the german IRCnet hubs), and
>  > from several boxen providing transparent proxy service to dialup customers,
>  > 3000 customers per box peak, running DNS and squid towards the Internet.
>  > With the peak load, the proxy boxen have up to 100000 conntrack entries
>  > (according to slabinfo; /proc/net/ip_conntrack is too lame to show them all).
>  > 
>  > Others will certainly be able to contribute data from production
>  > routing firewalls. I have one of those, too, but they only protect
>  > an ~50 workstation LAN, so these are not that significant.
> 
> If you can put some data on a web page that I could download I'd be
> happy to write and run the program that analyzes it and compares it
> to the results expected for a uniform hash function.

great. I'd definitley want to encourage the two of you to do some
furtherr research on the hashing function.

It's just a pity that I'm currently travelling and away from my test
boxes, so I won't be of much help.

Good work.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
