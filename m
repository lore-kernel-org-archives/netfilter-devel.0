From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Apply rules to 1 UDP port but port used as a socket: possible?
Date: Wed, 11 Feb 2004 08:53:07 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402110850220.23130-100000@filer.marasystems.com>
References: <D4EF10CCEB2CE742BEEA9838C590B0E80113FA46@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zze-Proxy GRALL O ext FTRD/SVA/LAN <ograll.ext@rd.francetelecom.com>
In-Reply-To: <D4EF10CCEB2CE742BEEA9838C590B0E80113FA46@ftrdmel2.rd.francetelecom.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 10 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> I'm trying to use a socket (on port 1727) to decode some proprietary UDP
> packets. When I've decoded them I want to apply a DNAT rule (and then a
> SNAT  too) to this port using a filter on @IP:port source for all
> following packets...

This will be tricky if you accept the packet on the socket. The problem is 
that the connection entry is then already set up and can not be NAT:ed.

You should be able to use QUEUE in a table before nat PREROUTING such as
mangle PREROUTING, allowing you to inspect the packet before the
connection is set up.

Regards
Henrik
