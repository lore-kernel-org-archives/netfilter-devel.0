From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] pkttype match mismatches on locally generated packets
Date: Mon, 17 Jul 2006 18:06:42 -0700
Message-ID: <20060718010642.GA1203@linuxace.com>
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

Locally generated broadcast and multicast packets have pkttype set to
PACKET_LOOPBACK instead of PACKET_BROADCAST or PACKET_MULTICAST.  This
causes the pkttype match to fail to match packets of either type.

The below patch remedies this by using the daddr as a hint as to
broadcast|multicast.  While not pretty, this seems like the only way
to solve the problem short of just noting this as a limitation of the match.

This resolves bug #484

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>
