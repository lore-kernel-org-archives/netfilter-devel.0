From: Telford Tendys <telford@triode.net.au>
Subject: TCPLAG new target for netfilter
Date: Mon, 14 Oct 2002 13:39:14 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014133914.A8251@ikkyu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

New target for iptables/netfilter to track how much lag
is on an TCP/IPv4 link and output to syslog. It's far from
perfect but I've had it running on my firewall for a week
and a bit without any drama. It is available in both stand
alone format and my attempt at a patch-o-matic format.
It is a passive target (like LOG) so it doesn't do any
actual filtering, merely logging.

   http://www.triode.net.au/~telford/TCPLAG


Hope its useful for someone...

	- Tel
