From: Valentijn Sessink <valentyn+netfilter-users@nospam.openoffice.nl>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 14:27:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127132725.GA14685@openoffice.nl>
References: <20040124082252.GA19035@alpha.home.local> <Pine.LNX.4.44.0401241015470.32723-100000@filer.marasystems.com> <20040124092721.GA19140@alpha.home.local> <20040127103917.GC11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Willy Tarreau <willy@w.ods.org>,
	Henrik Nordstrom <hno@marasystems.com>,
	Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040127103917.GC11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

At Tue, Jan 27, 2004 at 11:39:18AM +0100, Harald Welte wrote:
> I also disagree that an ESP packet should be trated as locally
> generated (and thus iterate over OUTPUT).

This is what happens with incoming packets: they hit INPUT twice.

>   From my perspective, locally
> generated means more something like: sent via a local userspace process
> using PF_INET sockets.  If we consider a packet after any kind of change 
> as locally-generated, we could argue doing this with NAT'ed packets,
> too.  Please try to convince me, if I'm missing some point.

You are missing the point that the netfilter code changes the packets here,
thus if you would want netfilter to do something else, you could code that
in netfilter rules.

Now let's review an IPsec tunnel. On the input side, everything works as
expected: an ESP packet hits PREROUTING, then INPUT, gets unencrypted, then
the new packet (that has different from and to, and may be a different
protocol altogether) hits PREROUTING again, then INPUT (or FORWARD).

On output, however, things are not so transparant. A packet hits OUTPUT,
then gets encrypted. A totally different packet hits POSTROUTING. This makes
no sense.

> One of the fundamental principles behind netfilter/iptables, especially
> NAT, is it's symmetric behaviour (between incoming and outgoing packets,
> between the hooks, ...).   So with any possible solution, this should be
> kept in mind.

There's no symmetric behaviour now. And from an "input" perspective, I think
a decapsulated packet that has a locally ending payload should hit INPUT
again. Same with output: a locally generated packet hits output, then should
hit OUTPUT again if it was really destined for the outside world.

V.
-- 
http://www.openoffice.nl/   Open Office - Linux Office Solutions
Valentijn Sessink  valentyn+sessink@nospam.openoffice.nl
