From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 08:10:23 -0400
Message-ID: <20050826121023.GB3067@ti64.telemetry-investments.com>
References: <20050826111832.GT4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline
In-Reply-To: <20050826111832.GT4226@rama.de.gnumonks.org>
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

On Fri, Aug 26, 2005 at 01:18:32PM +0200, Harald Welte wrote:
> The TTL target allows setting, incrementing and decrementing of the TTL,
> and is therefore extremely dangerous. OTOTH, there are ISP's that check
> whether you use a router or not (and thus filter or not) by looking at
> the TTL of every packet that comes in on your link - so there is a
> practical use of this to a number of people.
 
Sharp tools are sometimes a necessity.  IMHO, it's better to give people
a standard sharp tool and teach them to use it, than to have each invent
their own.  Besides the ISP use, there are other applications where a
bit of routing infrastructure sometimes needs to be transparent, e.g.,
passing packets to virtual environments.

Since Quagga does not grok interface bundles, I use TTL
and ROUTE to make hdlc[0123] packets appear to arrive on teql0:

$ sudo /sbin/iptables -t mangle -vL PREROUTING
Chain PREROUTING (policy ACCEPT 1317K packets, 97M bytes)
 pkts bytes target     prot opt in     out     source               destination         
 571K   19M TTL        all  --  hdlc+  any     anywhere             anywhere            TTL increment by 1 
 571K   19M ROUTE      all  --  hdlc+  any     anywhere             anywhere            ROUTE iif:teql0 

Two netfilter rules removed a rewrite of Quagga's interface handling from
our critical path.

So please, submit TTL for mainline, guarded by however many config layers of
"we're not kidding! last exit! turn back!" warnings are required. :-)

Regards,

	Bill Rugolsky
