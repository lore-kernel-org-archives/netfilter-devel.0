From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 18:27:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
	<42D14A6D.4000900@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42D14A6D.4000900@trash.net>
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

On Sun, 10 Jul 2005, Patrick McHardy wrote:

> you first. I don't see how this change can affect SO_ORIGINAL_DST
> though, all it does is look up the conntrack entry by a tuple
> generated from data stored in the socket. It never even gets to
> see a packet.

I would guess the problem is that there may be two conntracks for the 
session, one before nat and another after, or that the tuple lookup does 
not look at the expected tuple variant needed to find the conntrack.. If I 
understood the Jens problem correctly this traffic goes over loopback via 
DNAT..  (output -> DNAT -> loopback -> input -> socket)

Regards
Henrik
