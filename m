From: Yuval Pemper <YuvalP@Radware.com>
Subject: oops in replace_in_hashes
Date: Tue, 5 Aug 2003 12:32:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <45FCD7CD775DD411B4C100508B691BBB05C4EBAC@WARE-MAIL>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="WINDOWS-1255"
Cc: Sagi  Grabois <SagiG@Radware.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I saw the archived correspondence regarding this problem from July. We are
using Balazs Scheidler's tproxy patch on a proxy application and were able
to easily reproduce the oops with load that produced a high rate of new
client connections per second. Each client connection caused the opening of
a matching connection to the server side with the client's source IP and
source port.

For whatever it's worth, after applying the 20030728 patch-o-matic and the
latest tproxy patch available at the time (cttproxy-2.4.21-16) the oops
problem disappeared.

--
Yuval Pemper
