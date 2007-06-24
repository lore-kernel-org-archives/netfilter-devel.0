From: Adam Snodgrass <wolf@sarchasm.us>
Subject: Re: Possible 32/64-bit issue building/using iptables 1.3.7 with UML
 ("ERROR: 0 not a valid target)")
Date: Sun, 24 Jun 2007 18:10:50 -0400
Message-ID: <20070624181050.520b2179@megumi.wolf.fhi>
References: <20070620013626.47f3dfd9@megumi.wolf.fhi>
	<467D2946.4010106@trash.net>
Reply-To: wolf@sarchasm.us
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467D2946.4010106@trash.net>
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

On Sat, 23 Jun 2007 16:08:06 +0200
Patrick McHardy <kaber@trash.net> wrote:

> > guest# ./iptables -V
> > iptables v1.3.7
> > guest# ./iptables -nL
> > ERROR: 0 not a valid target)
> 
> Thats really strange. Could you try again with current -rc? I fixed
> the default table initialization so you might get a better error
> message.
> 

I pulled down a fresh copy of svn (I presume this is what you meant,
as I didn't see any newer releases than 1.3.7), and built a new set of
binaries, and ran into the same problem.  I had a sneaking suspicion
about the kernel tree I was building against, however, and decided to
swap it with a fresh one.  Another compile later, and I now have
working binaries for my i386 umls.  The only difference between my
kernel trees is that the former was originally used to build my amd64
uml kernels.  This is strange to me, as I thought that iptables only
needed access to the headers?

> > (If you're wondering why I don't just use the supplied package in
> > etch, it sadly lacks the NFLOG target, despite claiming to be
> > version 1.3.6). 
> 
> NFLOG was added in 1.3.7. It has a bug in that version though so you
> should use current -svn. We'll release a new version shortly I hope.
> 

I must have misread/misunderstood the changelog. :) 

Thanks for your input (and hard work on netfilter!), Patrick.


Adam Snodgrass
wolf@sarchasm.us
