From: Patrick Schaaf <bof@bof.de>
Subject: Re: Where is conntrack in the iptables chain?
Date: Mon, 25 Aug 2003 13:22:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825112217.GF423@oknodo.bof.de>
References: <20030823210837.GE6750@sunbeam.de.gnumonks.org> <20030825111112.16579.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030825111112.16579.qmail@web13907.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Aug 25, 2003 at 04:11:12AM -0700, Scott MacKay wrote:
> I was wondering, where in the iptables chain does
> conntrack start?  In the segment of the chain, does it
> ack before or after inserted rules (like QUEUE)?

What do you mean with 'does it ack'? conntracking is not supposed
to pass verdicts on a packet, it's just looking up tracking information
for a passing packet.

That connection lookup happens before all other hooks, i.e. before a
packet enters iptables in the mangle table PREROUTING chain. Thus,
even rules in the prerouting chain can already use the tracking
information.

Does that answer your question?

best regards
  Patrick
