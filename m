From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Sat, 24 Jan 2004 10:21:12 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401241015470.32723-100000@filer.marasystems.com>
References: <20040124082252.GA19035@alpha.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040124082252.GA19035@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 24 Jan 2004, Willy Tarreau wrote:

> That was my point too. Even if the packet is only encapsulated, from an IP
> point of view, this is a completely new locally generated packet, and we
> need to be able to apply filtering before and after encapsulation.

Yes, and to do that the required netfilter hooks needs to be added to the 
new IPSec code when packets leave the IP stack and enters IPSec or the 
reverse, similar to how there was hooks for the ipsecX: interfaces.

These hooks have not yet been done, mostly because nobody has contributed
the code adding these hooks to the new IPSec implementation in a 
reasonable manner I guess.

Regards
Henrik
