From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible 32/64-bit issue building/using iptables 1.3.7 with UML
 ("ERROR: 0 not a valid target)")
Date: Sat, 23 Jun 2007 16:08:06 +0200
Message-ID: <467D2946.4010106@trash.net>
References: <20070620013626.47f3dfd9@megumi.wolf.fhi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: wolf@sarchasm.us
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070620013626.47f3dfd9@megumi.wolf.fhi>
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
> Hi,
>
> I've encountered a strange problem while attempting to build and use a
> copy of iptables 1.3.7 userland.  I recently decided it was time to try
> using ulogd2 and NFLOG, as my systems are all at least 2.6.21.x.  I
> successfully built and used a copy of 1.3.7 on my amd64 host, running
> Debian etch and kernel 2.6.21.4 (vanilla, no patches), then proceeded
> to try building a 32-bit copy inside a UML (running i386 etch, and
> kernel 2.6.21.4).  I am compiling iptables against a copy of
> 2.6.21.4 (no funny POMng or other patches).  The software builds fine,
> but when I get strange errors when I try to use it.  For example:
>
> guest# ./iptables -V
> iptables v1.3.7
> guest# ./iptables -nL
> ERROR: 0 not a valid target)
>   

Thats really strange. Could you try again with current -rc? I fixed the
default table initialization so you might get a better error message.

> Aborted
> guest# ./iptables -j NFLOG -h
> iptables: target `NFLOG' has invalid size 76.
>   

Thats extremly odd since there is nothing arch specific in that
structure and we never changed it.

> guest#
>
> I found several references to the '0 not a valid target' message from
> early 2006, and note that the fix has been applied to mainline for some
> time now.  Could this be a UML problem?  (I can compile and run 1.3.7
> in an amd64 UML without issue).
>
> (If you're wondering why I don't just use the supplied package in etch,
> it sadly lacks the NFLOG target, despite claiming to be version 1.3.6).
>   

NFLOG was added in 1.3.7. It has a bug in that version though so you
should use current -svn. We'll release a new version shortly I hope.
