From: Patrick McHardy <kaber@trash.net>
Subject: Re: [SECURITY] DNAT'd host disclosure
Date: Fri, 03 Feb 2006 15:37:33 +0100
Message-ID: <43E36AAD.7050808@trash.net>
References: <20060202113824.GA4399@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wensong Zhang <wensong@linux-vs.org>, netfilter-devel@lists.netfilter.org,
	Roberto Nibali <ratz@drugphish.ch>, Moritz Muehlenhoff <jmm@inutil.org>,
	Micah Anderson <micah@riseup.net>, Julian Anastasov <ja@ssi.bg>,
	dann frazier <dannf@dannf.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Horms <horms@verge.net.au>
In-Reply-To: <20060202113824.GA4399@verge.net.au>
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

Horms wrote:
> I have been researching the vulnerability of various kernel versions to
> CVE-2002-0704, which is explained from various angles at:
> 
>   http://www.netfilter.org/security/2002-04-02-icmp-dnat.html
>   http://rhn.redhat.com/errata/RHSA-2002-086.html
>   http://www.securityfocus.com/bid/4699/discuss
> 
> In a nutshell, you can discover the internal IP address of a DNAT'd
> host by manipulating the TTL of packets sent, such that the expire
> between the DNATing and DNAT'd hosts.
> 
>   By DNATing host, I mean the machine that has the iptables DNAT rule
>   By DNAT'd, I mean the host that the connection is directed to, which
>   actually terminates the connection. So the packet path is:
> 
>   [end-user]----[some net]---[DNATing host]---[some more net]---[DNAT'd host]
> 
>   Sorry if this is confusing, I'm not sure what terms are usually used
> 
> I believe that this was resolved in 2.6.11 with the following patch
> http://www.kernel.org/git/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=1e69ba3fa29b13fe5229d6e325aee91ae5abe298

Yes, this one and the one to manually attach conntrack references to
locally generated ICMP errors.

> At the very least, 2.6.16-rc2 does not seem to exhibit this problem,
> while I have been able to reproduce it using 2.4.18, 2.4.27, 2.4.33-pre1
> and 2.6.8. (I can reverify individual versions if need be).
> 
> In the course of playing with this for far to long I believe that I have
> discovered two related vulnerabilities. 
> 
> I. Disclosure of intermediate hop addresses
> 
> I believe that the following patch, also included in 2.6.11 causes the
> IP address of intermediate hops between the DNATing and DNAT'd hosts to
> be trivially disclosed, as illustrated by the following tcptraceroute.
> 
> http://www.kernel.org/git/?p=linux/kernel/git/tglx/history.git;a=commit;h=8d5f3377d48c74df38990688f09e773887ba4eb5
> 
> # tcptraceroute 10.0.1.7 80
> Selected device ppp7, address 10.0.1.4, port 1942 for outgoing packets
> Tracing the path to 10.0.1.7 on TCP port 80 (www), 30 hops max
>  1  10.0.1.7  26.517 ms  25.262 ms  74.672 ms
>  2  192.168.1.254  76.070 ms  75.554 ms  75.988 ms
>  3  10.0.1.7 [open]  69.503 ms  114.771 ms  105.756 ms
> 
> The client now knows not only that 10.0.1.7 80 is DNAT'd but that
> there is an intermediate hop with the address 192.168.1.254. Which
> is similar to the disclosure made by CVE-2002-0704, where the IP
> address of hop 3 can be revealed using hbping (but not tcptraceroute).
> The intermediate hop information can also be revealed using hbping,
> and likely a variety of other tools.
> 
> I have a rather hackish patch, against today's Linus tree (~2.6.16-rc2)
> at the bottom of this message, which conceals the address, leading to
> the following output.

I'm surprised, IIRC I've tested that it still behaves fine with Rusty's
NAT changes. I'm going to try to reproduce this.

> # tcptraceroute 10.0.1.7 80
> Selected device ppp7, address 10.0.1.4, port 1952 for outgoing packets
> Tracing the path to 10.0.1.7 on TCP port 80 (www), 30 hops max
>  1  10.0.1.7  27.198 ms  72.374 ms  66.602 ms
>  2  10.0.1.7  68.898 ms  76.121 ms  66.639 ms
>  3  10.0.1.7 [open]  66.052 ms  107.855 ms  107.375 ms
> 
> 
> II. DNAT use exposure
> 
> I believe that all versions of the DNAT code back to at least the
> versions covered by CVE-2002-0704, and up to date allow TTL to be used
> to ascertain if a port is DNAT'd. Looking at the original description of
> CVE-2002-0704, and the two tcptracroutes above, it is easy to see that
> the port has been DNAT'd. While the last trace does not disclose much
> information, other than that DNAT is in use, and there are 2 hops after
> the DNATing host, it is still unwanted disclosure. Imagine a user
> whose ISP forbids the connection of networks, who is using DNAT (against
> the ISP's policy), and the ISP runs a check like this.
> 
> I do not have a proposal to fix this problem. I'm actually not sure if
> it is fixable. I would be interested to see what other DNAT
> implementations do. And at the very least, I would like this message to
> serve as documentation (or the start of documentation) of this problem.

Well, I'm not sure I agree that its a problem at all. NAT is not
meant for anonymizing traffic. There are other ways of determining
that NAT is used (timestamps, IP IDs, sequence numbers, ...).
Anyway, changing this behaviour would require not decrementing the
TTL for DNATed and forwarded packets, which means that you could
create loops in which the packets TTL never expires. I don't think
that this is a good idea.
