From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RE : Apply rules to 1 UDP port but port used as a socket:
 possible?
Date: Wed, 11 Feb 2004 12:54:14 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402111252360.25324-100000@filer.marasystems.com>
References: <D4EF10CCEB2CE742BEEA9838C590B0E80113FD36@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zze-Proxy GRALL O ext FTRD/SVA/LAN <ograll.ext@rd.francetelecom.com>
In-Reply-To: <D4EF10CCEB2CE742BEEA9838C590B0E80113FD36@ftrdmel2.rd.francetelecom.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 11 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> I think that receiving on the UDP socket set the table Conntrack  after the packet passed into the table Filter for the hook INPUT:

The conntrack is created immediately when the packet arrives at the box.

But the destination-NAT is only set in nat PREROUTING.

Once a single packet of the session has gone by nat PREROUTING the 
destination-NAT of that session is fixed and can not be changed.

As I said, you should be able to use QUEUE in mangle PREROUTING to inspect 
the first packet before it arrives to nat PREROUTING.

Regards
Henrik
