From: Patrick McHardy <kaber@trash.net>
Subject: Re: AW: patch: Port- and netscan detection for netfilter
Date: Mon, 19 Mar 2007 05:59:00 +0100
Message-ID: <45FE1894.3070506@trash.net>
References: <DF74C782E6463841A9BD3322977588813532AB@FHCLUSRV-EX.dcs.fh-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Gladewitz, Robert (FH)" <Robert.Gladewitz@fh-heidelberg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <DF74C782E6463841A9BD3322977588813532AB@FHCLUSRV-EX.dcs.fh-heidelberg.de>
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

Gladewitz, Robert (FH) wrote:
> The problem is, on the most attacks, the hacker try to get some information on the network. This module implements 3 different situations:

Putting aside the question of the usefulness of this, whats the
difference to using the three rules below?

> - Netscan (Scan more hosts on less ports)

iptables -A PREROUTING -m state --state NEW \
		       -m hashlimit --hashlimit-name netscan \
				    --hashlimit-mode dstip \
				    --hashlimit n/sec \
		       -j DROP

> - Portscan (Scan less Hosts and many ports)

iptables -A PREROUTING -m state --state NEW \
		       -m hashlimit --hashlimit-name portscan \
				    --hashlimit-mode dstport \
				    --hashlimit n/sec \
		       -j DROP

> - Combined Scan (Scan many Ports on many)

iptables -A PREROUTING -m state --state NEW \
		       -m hashlimit --hashlimit-name portnetscan \
				    --hashlimit-mode dstip,dstport \
				    --hashlimit n/sec \
		       -j DROP
