From: Patrick Schaaf <bof@bof.de>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: Fri, 13 Dec 2002 13:06:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021213120625.GA21253@oknodo.bof.de>
References: <1039702486.2373.17.camel@pc> <Pine.LNX.4.44.0212130314131.2834-100000@shieldbreaker.l33tskillz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Ralston <qralston+ml.netfilter-devel@andrew.cmu.edu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0212130314131.2834-100000@shieldbreaker.l33tskillz.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Failing a helper, I'm unable to come up with anything better than
> adjusting timeouts on a per-port basis...

What about a single new target, CTTIMEOUT or something, having a single
parameter, a relative timeout in seconds. Whenever that target hits,
and we have a connection hanging off our skb, the connection's timeout
will be refreshed to now+the_given_timeout.

This could be equally used to lower TCP ESTABLISHED timeouts for
certain uses, and for extending the UDP timeouts discussed here.
You would use normal, arbitrary matches to select _which_ packets
should receive the treatment.

I have not thought about the interplay with the current automatic
timeout selection. Anybody?

best regards
  Patrick
