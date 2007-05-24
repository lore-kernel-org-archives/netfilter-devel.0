From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_rt_bug in mangle/OUTPUT
Date: Thu, 24 May 2007 19:50:59 +0200
Message-ID: <4655D083.8070309@trash.net>
References: <4654AE59.3090506@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4654AE59.3090506@cpsc.ucalgary.ca>
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

Rennie deGraaf wrote:
> I seem to be getting the error message
>     ip_rt_bug: 10.1.1.1 -> 10.0.1.2, ?
> whenever I attempt to send a packet with a non-local source IP address
> (my local IP address is 10.0.1.2) from libipq in mangle/OUTPUT.  I have
> observed this behaviour under Linux kernels 2.6.20.7 and
> 2.6.18-1.2257.fc5smp (Fedora Core 5), and iptables versions 1.3.5 and
> 1.3.7.
> 
> I'm trying to simulate connections with remote hosts by redirecting
> packets to servers listening on localhost.  My strategy is to send
> packets to IP_QUEUE from rules in the mangle/OUTPUT chain: destination
> addresses are re-written on packets that I want to redirect, source
> addresses are re-written on packets on responses to redirected packets,
> and other packets are passed without modification.  A simplified, highly
> stripped down version of my program is attached.
> 
> To run my example program, you need rules in your mangle/OUTPUT chain
> forwarding packets to 10.1.1.1:123/TCP and from 127.0.0.1:22/TCP to
> QUEUE, and something listening on 127.0.0.1:22/TCP.  If it worked
> properly, a connection could be successfully established to
> 127.0.0.1:22/TCP by connecting to 10.1.1.1:123/TCP (using telnet, for
> instance).
> 
> Do any of the gurus on this list know how I might fix or work around
> this issue?


If you don't need the rerouting to be happen (you only change the
source address and don't use routing rules based on that) you can
simply return NF_STOP instead of NF_ACCEPT. It will do exactly
the same thing but avoid rerouting.

> This issue seems to have been discussed before (such as
> http://www.ussg.iu.edu/hypermail/linux/kernel/0504.3/0159.html), but
> doesn't seem to have been resolved.


The solution suggested there doesn't work since we've moved
the okfn invocation to the caller of nf_hook_slow() and I'm
hoping we can some day get rid of the okfn function pointer
entirely.
