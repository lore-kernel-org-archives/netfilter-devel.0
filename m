From: Simon Kirby <sim@netnation.com>
Subject: REJECT using invalid data
Date: Mon, 6 Dec 2004 17:01:31 -0800
Message-ID: <20041207010130.GC4757@netnation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,

After some recent interesting network issues involving an onboard Tigon3
card with faulty buffer memory, we discovered that netfilter has some
issues with handling corrupted packets.  This took quite some time to
diagnose, I might add. :)

It appears that a packet with a bad TCP checksum will be disregarded by
the state tracking code (and apparently shows up as "INVALID").  Fine.

However, the same packet will then likely continue traversing rules until
it hits some kind of REJECT rule.  REJECT can be set to reject with a
tcp-reset or some ICMP response at this point.  If so, it will actually
use the possibly-incorrect information from the bad TCP packet and send a
rejection packet.  As far as I can tell, this is a bug.

What happens as a result of this is that any corrupted packet will result
in TCP sessions being immediately terminated.  This is bad because
normally TCP would retransmit and recover from the error.

I'm quite busy but I can look at creating a patch for this if nobody has
any immediate objections (or already knows how to easily make the patch). 

Thanks,

Simon-
