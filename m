From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] User defined udp and tcp conntrack state timeouts
Date: Wed, 18 Sep 2002 23:45:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918214534.GC10465@oknodo.bof.de>
References: <Pine.LNX.4.44L.0209180137170.10390-101000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jay Schulist <jschlst@linux-sna.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0209180137170.10390-101000@hunger.screamingdaemon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The timeout values are based on connection tracking states and are in
> linux hertz (HZ).

Why why why? It's a user interface. The users know seconds. Don't bother
them with that hertz stuff. Using hertz units are guaranteed to change,
eventually, and then both human habit, and boot scripts, will suddenly
(upon a kernel upgrade) start to do silly things.

Better avoid it in the first place, and convert internally, if it's
not too much hassle. Isn't there a suitable sysctl helper for this
situation? I vaguely remember something like that. Show seconds to
the user, convert to internal format (eg. HZ) upon modification.

best regards
  Patrick
