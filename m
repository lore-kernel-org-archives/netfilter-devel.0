From: Willy Tarreau <willy@w.ods.org>
Subject: Re: NAT before IPsec with 2.6
Date: Sat, 24 Jan 2004 09:22:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040124082252.GA19035@alpha.home.local>
References: <Pine.LNX.4.44.0401231521350.13626-100000@filer.marasystems.com> <200401230751.40618.teastep@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>, Michal Ludvig <mludvig@suse.cz>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
Content-Disposition: inline
In-Reply-To: <200401230751.40618.teastep@shorewall.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Fri, Jan 23, 2004 at 07:51:40AM -0800, Tom Eastep wrote:
 
> I'm concerned that passing the unencrypted packet through POSTROUTING 
> apparently makes it impossible for firewall rules to enforce encryption to a 
> remote host or network.
> 
> It's my opinion that when the ipsec<n> devices where eliminated, the baby got 
> thrown out with the bath water.

That was my point too. Even if the packet is only encapsulated, from an IP
point of view, this is a completely new locally generated packet, and we
need to be able to apply filtering before and after encapsulation.

Willy
