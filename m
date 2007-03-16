From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: patch: Port- and netscan detection for netfilter
Date: Fri, 16 Mar 2007 22:32:26 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703162231110.29521@yvahk01.tjqt.qr>
References: <DF74C782E6463841A9BD332297758881121069@FHCLUSRV-EX.dcs.fh-heidelberg.de>
	<45FABA87.4090601@trash.net> <45FAC7B7.40806@tpi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	"Gladewitz, Robert \(FH\)" <Robert.Gladewitz@fh-heidelberg.de>
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FAC7B7.40806@tpi.com>
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


On Mar 16 2007 10:37, Tim Gardner wrote:
>
>One benefit of being able to block a port scanner is that it reduces or
>stops the amount of ARP traffic that is generated. Depending on your
>internal network design, lots of ARP traffic can have a significant
>impact on WAN links and so on.

ARP traffic is hardly a problem when the attacker is at least two hops away
(which is always true in the Internet except when your own ISP pokes on you) or
there is a NOARP link at hop 1 (as is the case with PPP/etc.).


Jan
-- 
