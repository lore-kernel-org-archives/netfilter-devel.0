From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp match silently drops packets
Date: Sun, 16 Oct 2005 23:07:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
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

On Sun, 16 Oct 2005, Henrik Nordstrom wrote:

> The above code forces such packets to be dropped with no visible traces to 
> why. (*hotdrop = 1, and also hinted by the debug message and comment)

Just a comment on why the tcp port match hotdrops "too small" packets:

The reason why this match hotdrops such packets is to deal with attacks 
using fragmented packets in a reasonably secure manner without having to 
rely on "UNCLEAN" or similar. A TCP packet so small that it does not even 
include the TCP header is below the minimum MTU allowed and you should not 
see any such fragments in normal traffic.

As the match can not tell it it matches or not when the packet is 
fragmented in this odd manner the safest path is taken to drop the packet 
on the floor, preventing hackers to too easily bypass the firerewall rule 
by using unnaturally fragmented IP packets.

For the exact same reason the match also hotdrops fragments which would 
overwrite the TCP header.

In theory just the second criteria is a must (drop fragments which could 
override an earlier decision), but as it's there the first also makes 
sense to drop the first as we can not allow a fragment filling in the 
missing pieces.

The third hotdrop condition in the tcp_match is perhaps a bit more 
questionable (hotdrop if rule looks for an tcp option, and the data 
pointer is corrupted).

The fourth hotdrop condition can very much be questioned. (hotdrop if 
matching for an tcp option and not all options fit in the first fragment). 
The list of TCP options can get farily long, especially if some 
experimental options are used and there may in theory be perfectly natural 
cases where the IP packet got fragmented within the options  (in practise 
no such large amounts of tcp options are used making this a problem..)

Regards
Henrik
