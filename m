From: IPLNet - PedroRibeiro <pribeiro-bulk@net.ipl.pt>
Subject: Problems using custom module
Date: Mon, 10 Nov 2003 19:58:05 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <115121565453.20031110195805@net.ipl.pt>
Reply-To: IPLNet - PedroRibeiro <pribeiro-bulk@net.ipl.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I'm trying to develop a very simple "match" module for iptables based
on a modified version of "ipt_ttl.c" that i'v called "ipt_ttlhhd.c"
(does some heuristics based on TTL to estimate the hop distance and
match)

I'v made the changes to the Makefile to compile the module, compiled
it with success but when i'm trying to use it, I always get the error:

>> iptables v1.2.7a: Couldn't load match `ttlhhd':/lib/iptables/libipt_ttlhhd.so: cannot open shared object file: No such file or directory

Even with the module built in the kernel the problem persists.

My base questions are:

Why do I need that lib (i'v found the originals installed with the
Linux RH9 in /lib/iptables/ ) ?

Even with the module compiled in the kernel the lib is needed ?

How do I compile it ? (is there a tutorial for that ?)

Does this means that the kernel is always tied with the libs ?

Where is the "code" to execute the task, in the kernel/module or in
the lib ?

TIA!

PS: Great work guys, iptables rocks! (hope to also contribute soon!)

-- 
Best regards,
 IPLNet                          mailto:pribeiro-bulk@net.ipl.pt
