From: Martijn Lievaart <m@rtij.nl>
Subject: Re: [PATCH 2.6] Allow dynamic helper-port assignment
Date: Mon, 14 Feb 2005 12:59:40 +0100
Message-ID: <421092AC.30709@rtij.nl>
References: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>Hi!
>
>The recent problem with h323 made me again consider the old idea of
>having runtime-configurable port assignments for helpers. 
>
>Ideally, we would actually have conntrack helpers be iptables targets,
>this way allowing totally dynamic assignemnt.  Maybe yet another
>pkttables todo.
>  
>

I've already been thinking about this before you mentioned it. Here's 
one way it could be done.

If a helper is loaded with the argument "noauto" (f.i.) it does not 
register the default ports, otherwise it does. This keeps backward 
compatibility, does what you want in general, but still gives a way out 
for those people who run ssh over port 21.

Additional ports can be registered with a target, f.i. "-p tcp -p 666 -s 
<someip> -j HELP --helper ftp". This would add a helper for this 
specific connection. Obviously, people that load modules with noauto 
need to help all connections themselves.

Pro:
+ Backward compatible
+ In general does the right thing while also allowing all flexibilty one 
could want.
Con:
- Looks like a lot of work to implement.
- Increases size of contrack structure? Can use that new contack 
extension thingy introduced lately if this crops up.

I already looked at the source to see if it was feasable, but decided it 
was a bit to much for me.

M4
