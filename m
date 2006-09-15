From: Patrick McHardy <kaber@trash.net>
Subject: Re: double-free bug and a question
Date: Fri, 15 Sep 2006 23:05:07 +0200
Message-ID: <450B1583.2090703@trash.net>
References: <Pine.LNX.4.64.0609141621400.27445@mariner.cs.ucdavis.edu>
	<450A2B12.4010503@trash.net>
	<Pine.LNX.4.64.0609151009060.623@mariner.cs.ucdavis.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jingmin Zhou <zhouji@cs.ucdavis.edu>
In-Reply-To: <Pine.LNX.4.64.0609151009060.623@mariner.cs.ucdavis.edu>
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

jmzhou.ml@gmail.com wrote:
> Thanks for the information.
> 
> As you said, for a simple range in either source or destination port,
> multiport is not needed. However, iptables allows me to specify either
> --sports or --dports or --ports with a simple range. Anyway, this detail
> is not important to my question.
> 
> My question is actually different from the crash example. I have a set
> of source ports (e.g., 53, 55, 57) and a set of destination ports (e.g.,
> 1023, 1025, 1027). They are different sets. How can I specify both sets
> in a single iptables rule? That means I want to match a packet that has
> a source port of 53, 55 or 57 and a destination port of 1023, 1025 or
> 1027? As the manual says, it seems --ports is not the option for me.

Looking at the code, its not possible. Multiport can only match either
source or destination, but current SVN version of iptables supports
multiple instances of the same match in once rule, so you can use
-m multiport twice.

> 
> Here's the stack backtrace, hope it helps. I'm running the command on
> Slackware -current (11.0rc) with kernel 2.6.16.18.
> 
> (gdb) run -A INPUT --protocol udp -m multiport --dports 65530:65535 -m
> multiport --sport 53:67 -j ACCEPT
> Starting program: /usr/sbin/iptables -A INPUT --protocol udp -m
> multiport --dports 65530:65535 -m multiport --sport 53:67 -j ACCEPT
> (no debugging symbols found)
> (no debugging symbols found)
> (no debugging symbols found)
> (no debugging symbols found)
> (no debugging symbols found)
> (no debugging symbols found)
> (no debugging symbols found)
> (no debugging symbols found)
> (no debugging symbols found)
> *** glibc detected *** double free or corruption (!prev): 0x08055160 ***
> 
> Program received signal SIGABRT, Aborted.
> 0xb7e67847 in raise () from /lib/tls/libc.so.6
> (gdb) where
> #0  0xb7e67847 in raise () from /lib/tls/libc.so.6
> #1  0xb7e690d9 in abort () from /lib/tls/libc.so.6
> #2  0xb7e9b616 in __libc_message () from /lib/tls/libc.so.6
> #3  0xb7ea1d4f in _int_free () from /lib/tls/libc.so.6
> #4  0xb7ea20ea in free () from /lib/tls/libc.so.6
> #5  0x0804c327 in clear_rule_matches ()
> #6  0x0804d759 in do_command ()
> #7  0x08049d10 in main ()

Thanks, this seems to be already fixed in SVN revision r6465.
