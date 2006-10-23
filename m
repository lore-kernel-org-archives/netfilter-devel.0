From: Patrick McHardy <kaber@trash.net>
Subject: Re: --dport in uml crash
Date: Tue, 24 Oct 2006 01:17:00 +0200
Message-ID: <453D4D6C.5050508@trash.net>
References: <1161644625.8705.16.camel@LAPTOP4.MSHOME>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: oan@frozentux.net
In-Reply-To: <1161644625.8705.16.camel@LAPTOP4.MSHOME>
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

Oskar Andreasson wrote:
> Using UML kernel 2.6.18 and iptables-1.3.6. 
> Specifying iptables -A INPUT -p tcp --dport 23 -j ACCEPT generates a
> hard crash of the UML system. 
> -j ACCEPT on it's own works flawless and -p tcp also works flawless, so
> i assume it's the --dport causing the crash for some reason. 

It is reproducable?

> I've been unable to get a look at the error messages since the xterm
> closes down before I get a chance to read it (lots of something scrolls
> by before closing however), any suggestions on how to get the errors are
> welcome, or if anyone else can replicate them would also be welcome :). 
> 
> Let me know if there is any more information that might be needed, or if
> this is an UML related bug?

Based on my experience I would guess that its UML, but it works pretty
reliable in the past few month for me. I'm unable to reproduce the
problem, can you send me your config please?

You could also get the "umlgdb" script and run uml in debug mode,
gdb should be able to tell you more.
