From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 12:03:38 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15644.45834.373409.220647@isis.cs3-inc.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
	<20020628082339.I2890@oknodo.bof.de>
	<15644.41633.528107.723418@isis.cs3-inc.com>
	<20020628203624.A4136@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020628203624.A4136@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 > I have real data from an IRC server (one of the german IRCnet hubs), and
 > from several boxen providing transparent proxy service to dialup customers,
 > 3000 customers per box peak, running DNS and squid towards the Internet.
 > With the peak load, the proxy boxen have up to 100000 conntrack entries
 > (according to slabinfo; /proc/net/ip_conntrack is too lame to show them all).
 > 
 > Others will certainly be able to contribute data from production
 > routing firewalls. I have one of those, too, but they only protect
 > an ~50 workstation LAN, so these are not that significant.

If you can put some data on a web page that I could download I'd be
happy to write and run the program that analyzes it and compares it
to the results expected for a uniform hash function.

Let me know what hash functions particularly interest you other than
the one currently in conntrack and the slight modification I
suggested. 

Just in case you consider this to be a drawback, I might as well
mention up front that this program will be written in lisp.
(I consider it to be a benefit.)

I suppose /proc/net/ip_conntrack is the preferred data format, but
if you have data in another format that others can easily generate
that would also be fine.
