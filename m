From: Martin Renold <martinxyz@gmx.ch>
Subject: Re: [patch] tcp connection tracking 2.4.19
Date: Thu, 17 Oct 2002 22:29:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021017202935.GA5067@old.homeip.net>
References: <20021016074837.GA18011@old.homeip.net> <20021016224643.GC2408@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20021016224643.GC2408@naboo.club.berlin.ccc.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Oct 17, 2002 at 12:46:43AM +0200, Harald Welte wrote:
> On Wed, Oct 16, 2002 at 09:48:37AM +0200, Martin Renold wrote:
> The question is whether this is really to be called a 'bug'.  Netfilter
> connection tracking never claimed to do full state tracking, neither did
> it claim to do sequence number tracking.  It does all it can without
> tracking sequence/ack numbers and window sizes.
> 
> You can also send FIN flagged packets with a wrong sequence number to 
> terminate a connection (conntrack entry, that is).

Well, I think the point is that if somebody sends a bad FIN (or RST)
packet, he has to know both used port numbers, and even then I perhaps
wouldn't care, I would still be able to establish a new connection.

I do not want a full state tracking, I just don't like being shut out of
my system for several days. And I called it a bug because one half of the
code to handle this situation was already there.

bye,
Martin
