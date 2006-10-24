From: Patrick McHardy <kaber@trash.net>
Subject: Re: CLUSTERIP and UML crash, was [Re: --dport in uml crash]
Date: Tue, 24 Oct 2006 17:48:05 +0200
Message-ID: <453E35B5.5010600@trash.net>
References: <1161644625.8705.16.camel@LAPTOP4.MSHOME>	
	<453D4D6C.5050508@trash.net>
	<1161680257.8705.31.camel@LAPTOP4.MSHOME>	
	<453E2220.3090506@trash.net>
	<1161704038.8705.51.camel@LAPTOP4.MSHOME>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: oan@frozentux.net
In-Reply-To: <1161704038.8705.51.camel@LAPTOP4.MSHOME>
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
> Hi Patrick,
> 
> You seem to be right yes, regarding module loading/handling. I don't
> dare say anything more, but a non-qualified guess is that it feels like
> some kind of bug between how the UML kernel handles modules and how
> iptables interact?

Mhh I guess thats rather unlikely, iptables modules do nothing special.
Any change your /sbin/modprobe is also linked against the wrong libc
or something like that (and command-line uses /usr/local/sbin/modprobe)?

> I've attached 3 more scenarios. 
> 
> 1. just restarted, issuing 
> iptables -t nat -A PREROUTING -j DNAT --to 192.168.10.2
> lsmod
> result: kernel panic from lsmod
> 
> 2. just restarted, issuing
> iptables -t nat -A POSTROUTING -j MASQUERADE
> lsmod
> result: kernel panic, exactly the same as first scenario (except for a
> couple of addresses). 
> 
> 3. just restarted, issuing
> modprobe ipt_MASQUERADE
> modprobe ip_tables
> lsmod
> iptables -t nat -A POSTROUTING -j MASQUERADE
> lsmod
> result: the last lsmod results in a kernel panic. 
> 
> All modules loaded with modprobe seems to work just fine, until iptables
> touches them. 
> 
> I just tried starting an nfs kernel server also, which didn't seem to
> work either, so it seems mostly like an UML bug. It crashed at lsmod as
> well. 
> 
> Would you know which way is the best to get in touch with the
> uml-people, and how to debug this? My experience with gdb is ...
> somewhat limited. I guess now is as bad a time as any to finally sit
> down with it :(. Suggestions on what to read are welcome.

There's a mailing list at

M:      jdike@karaya.com
L:      user-mode-linux-devel@lists.sourceforge.net
L:      user-mode-linux-user@lists.sourceforge.net
