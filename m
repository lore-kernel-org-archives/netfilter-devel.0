From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 20:36:24 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020628203624.A4136@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15644.41633.528107.723418@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Fri, Jun 28, 2002 at 10:53:37AM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>  > May I suggest a different, experimental approach: extract the hash function
>  > from the code, creating a small userlevel tool which reads in the saved
>  > contents of some /proc/net/ip_conntrack, and with a hash bucket and limit
>  > specified on the commandline, counts the distribution for that specific
>  > set of connections, maybe comparing it with the theoretical prediction,
>  > resulting in a "how does that real world conntrack table fit to theory"
>  > metric? Once done, such a tool could permit command line selection of
>  > different hash functions, for comparison.
> 
> Sounds easy enough.  You have some "real" (or at least "realistic") data?

I have real data from an IRC server (one of the german IRCnet hubs), and
from several boxen providing transparent proxy service to dialup customers,
3000 customers per box peak, running DNS and squid towards the Internet.
With the peak load, the proxy boxen have up to 100000 conntrack entries
(according to slabinfo; /proc/net/ip_conntrack is too lame to show them all).

Others will certainly be able to contribute data from production
routing firewalls. I have one of those, too, but they only protect
an ~50 workstation LAN, so these are not that significant.

best regards
  Patrick
