From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ippool -X not working
Date: Tue, 9 Dec 2003 00:28:24 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312090020050.14902-100000@filer.marasystems.com>
References: <1070905216.813.11.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rodrigo Severo <rodrigo.lists@fabricadeideias.com>,
   Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1070905216.813.11.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 8 Dec 2003, Martin Josefsson wrote:

> Maybe it's time someone wrote a small installation-howto, and maybe
> replaced the code in netfilter cvs with this code as it works a lot
> better than the old code (the old code might work well with Henrik's
> patches, I've never used them...)

Have not experienced any problems with the modified code, and we have been
using this code for very long now. But I have to admit that we do have
some other patches extending the old ippool code with new functionality
but this has not been publishet yet for the same reasons as the
flush/destroy patch was not published.

As you may remember I have some minor objections to the user/kernel
interface of the new code (the use of kernel space pointers as pool
identifiers) but this is only minor and manageable. One could say that I
do not get why not using the pool name or a simple integer is not better.  
if this still is the same in the current implementation then I still have
that objection.

Note: The UltraSparc port will have issues from this "pointer abuse", in
addition to the pointer size issues it already have with iptables..

Regards
Henrik
