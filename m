From: Patrick McHardy <kaber@trash.net>
Subject: Re: double-free bug and a question
Date: Fri, 15 Sep 2006 06:24:50 +0200
Message-ID: <450A2B12.4010503@trash.net>
References: <Pine.LNX.4.64.0609141621400.27445@mariner.cs.ucdavis.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jingmin Zhou <zhouji@cs.ucdavis.edu>
In-Reply-To: <Pine.LNX.4.64.0609141621400.27445@mariner.cs.ucdavis.edu>
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
> Apology if this has been reported. Here's the way to reproduce the crash:
> 
> # iptables -A INPUT --protocol udp -m multiport --dports 65530:65535 -m
> multiport --sport 53:67 -j ACCEPT
> *** glibc detected *** double free or corruption (!prev): 0x08055160 ***
> Abort (core dumped)
> 
> # iptables -A INPUT --protocol udp -m multiport --dports 65530:65535 -m
> multiport --sports 53:67 -j ACCEPT
> Bad argument `53:67'
> Try `iptables -h' or 'iptables --help' for more information.
> 
> $ iptables --version
> iptables v1.3.5
> 
> 
> What I want to do is to define multiple ports for both source and
> destination in a single iptables rule. Is there any way to do it?
> Thanks!

Read the help for multiport, the ports are given as comma-seperated
list. For simple ranges you don't need multiport. For source and
destination you must only specify "-m multiport" once.

I have no idea where the crash comes from (works fine here). Please
try to get a backtrace by running the command in gdb:

gdb iptables

(gdb) run -A INPUT ...
<crash>
(gdb) backtrace
