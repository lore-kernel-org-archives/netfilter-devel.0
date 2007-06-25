From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible 32/64-bit issue building/using iptables 1.3.7 with UML
 ("ERROR: 0 not a valid target)")
Date: Mon, 25 Jun 2007 12:26:30 +0200
Message-ID: <467F9856.8030409@trash.net>
References: <20070620013626.47f3dfd9@megumi.wolf.fhi>	<467D2946.4010106@trash.net>
	<20070624181050.520b2179@megumi.wolf.fhi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: wolf@sarchasm.us
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070624181050.520b2179@megumi.wolf.fhi>
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

Adam Snodgrass wrote:
> On Sat, 23 Jun 2007 16:08:06 +0200
> Patrick McHardy <kaber@trash.net> wrote:
> 
> 
>>>guest# ./iptables -V
>>>iptables v1.3.7
>>>guest# ./iptables -nL
>>>ERROR: 0 not a valid target)
>>
>>Thats really strange. Could you try again with current -rc? I fixed
>>the default table initialization so you might get a better error
>>message.
>>
> 
> 
> I pulled down a fresh copy of svn (I presume this is what you meant,
> as I didn't see any newer releases than 1.3.7), and built a new set of
> binaries, and ran into the same problem.  I had a sneaking suspicion
> about the kernel tree I was building against, however, and decided to
> swap it with a fresh one.  Another compile later, and I now have
> working binaries for my i386 umls.  The only difference between my
> kernel trees is that the former was originally used to build my amd64
> uml kernels.  This is strange to me, as I thought that iptables only
> needed access to the headers?


Its possible that some alignment constant or a data type depends
on a correctly setup include/asm symlink. Doesn't seem to be a
bug at least ..
