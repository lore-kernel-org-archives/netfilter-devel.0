From: Patrick McHardy <kaber@trash.net>
Subject: Re: patch: Port- and netscan detection for netfilter
Date: Fri, 16 Mar 2007 17:57:59 +0100
Message-ID: <45FACC97.2050701@trash.net>
References: <DF74C782E6463841A9BD332297758881121069@FHCLUSRV-EX.dcs.fh-heidelberg.de>	<45FABA87.4090601@trash.net>
	<45FAC7B7.40806@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, "Gladewitz,
	Robert \(FH\)" <Robert.Gladewitz@fh-heidelberg.de>
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

Tim Gardner wrote:
> Patrick,
> 
> One benefit of being able to block a port scanner is that it reduces or
> stops the amount of ARP traffic that is generated. Depending on your
> internal network design, lots of ARP traffic can have a significant
> impact on WAN links and so on.

Good point.
