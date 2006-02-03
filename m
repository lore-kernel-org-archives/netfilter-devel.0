From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [SECURITY] DNAT'd host disclosure
Date: Fri, 03 Feb 2006 17:42:54 +0100
Message-ID: <43E3880E.5020807@tac.ch>
References: <20060202113824.GA4399@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wensong Zhang <wensong@linux-vs.org>, netfilter-devel@lists.netfilter.org,
	Roberto Nibali <ratz@drugphish.ch>, Moritz Muehlenhoff <jmm@inutil.org>,
	Juergen Anthamatten <Anthamatten@terreActive.ch>,
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

Hello,

> Also, if these problems are well known, I'd appreciate pointers
> to prior discussions, or at least a pointer to where to find
> prior discussions.

A similar or related technique (using IP TTL lifetime fiddling) was
presented in 1998 in a paper called "Firewalking. A traceroute-like
Analysis of IP Packet Responses to Determine Gateway Access Control Lists":

http://www.packetfactory.net/projects/firewalk/firewalk-final.pdf

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

I wouldn't know the correct terms either.

> I believe that this was resolved in 2.6.11 with the following patch
> http://www.kernel.org/git/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=1e69ba3fa29b13fe5229d6e325aee91ae5abe298
> 
> At the very least, 2.6.16-rc2 does not seem to exhibit this problem,
> while I have been able to reproduce it using 2.4.18, 2.4.27, 2.4.33-pre1
> and 2.6.8. (I can reverify individual versions if need be).

I haven't been able to reproduce it on our 2.4.x kernels (2.4.32
currently but quite some out-of-mainline-tree patches), so maybe we need
to supply more information:

- firewall policy on chains
- ESTABLISHED and RELATED ruleset
- DNAT rule
- proc-fs settings:

  grep . /proc/sys/net/ipv4/* /proc/sys/net/ipv4/conf/{all,eth0,eth1}/*

  eth0 and eth1 being the DNATing host's interfaces

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

Not directly reproduceable here in the lab using 2.4.x kernels and the
latest tcptraceroute. I get the behaviour like you show in your patched
kernel example.

> # tcptraceroute 10.0.1.7 80
> Selected device ppp7, address 10.0.1.4, port 1952 for outgoing packets
> Tracing the path to 10.0.1.7 on TCP port 80 (www), 30 hops max
>  1  10.0.1.7  27.198 ms  72.374 ms  66.602 ms
>  2  10.0.1.7  68.898 ms  76.121 ms  66.639 ms
>  3  10.0.1.7 [open]  66.052 ms  107.855 ms  107.375 ms

This is what I get. Netfilter logs a RELATED ICMP in the output chain of
the filter table, however the RR entry of the host which had the
exceeded TTL is not sent back to the original host. tcpdump -s 0 -X icmp
traces do not contain the reveiling payload when examined.

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

This is a common way we do our vulnerability assessments. OTOH we
certainly do not want our packet filters to expose this information, so
below are a couple of possible (not very nice) solutions.

> I do not have a proposal to fix this problem. I'm actually not sure if
> it is fixable. I would be interested to see what other DNAT
> implementations do.

I could check for the Raptor Firewall (now Symantec Enterprise Firewall)
and the Checkpoint NGX. I believe they both have means to either drop
the ICMP TTL exceeded message or instrument the TTL itself on ingress
and egress. It's been a while since I've configured any of the above
products, so I need to check the documentation first.

> And at the very least, I would like this message to
> serve as documentation (or the start of documentation) of this problem.

Very well. I hope this yields an interesting discussion.

> This problem also seems to be exhibited in LVS. Although it only
> discloses that DNAT (in the form of LVS-NAT) is in use, not how many
> hops are taken, as only one additional hop is shown, regardless of how
> many hops there actually hare. The tcptraceroute below was using an
> LVS-NAT setup with 2 hops from the DNATing host to the DNAT'd host using
> today's Linus tree (~2.6.16-rc2).

Is the TTL decremented in LVS-NAT? I have to think about this a bit. I
vaguely remember some patches in the past (4-5 years ago) from Julian
regarding the ICMP handling in LVS-NAT.

> # tcptraceroute 10.0.1.7 80
> Selected device ppp7, address 10.0.1.4, port 1973 for outgoing packets
> Tracing the path to 10.0.1.7 on TCP port 80 (www), 30 hops max
>  1  10.0.1.7  67.788 ms  71.196 ms  85.573 ms
>  2  10.0.1.7 [open]  65.745 ms  105.648 ms  68.284 ms
> 
> I am one of the LVS maintainers, I have CCed the others, along with my
> colleagues who look after security for the Debian Kernel.

Thanks for the heads-up, Horms.

Now as for possible solutions I see the following approaches (I don't
necessarily claim them to be intelligent nor feasible):

a. Deny/drop ICMP TTL exceeded messages through proc-fs (rp_filter
   extension, maybe rp_filter_icmp) or by an explicit ruleset. However
   it's questionable if the ruleset works when conntrack is enabled.

b. Make the ICMP RELATED code check for FIB scope in expectation. This
   will probably not work with raw tables.

c. Write an ICMP handler/helper module which inspects ICMP packets and
   rewrites/overwrites IP information not pertaining to FIB scope of
   expectation tuple. This is similar to 2.

d. Reset TTL option (either don't decrement or set to an arbitrary
   number). Egress could be a place?.

I should like to note, however, that the common sense or best practice
approach regarding this problem among commercial firewall vendors seems
to be blocking outgoing ICMP TTL exceeded messages and/or instrumenting
the TTL.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
10 Jahre Kompetenz in IT-Sicherheit.              1996 - 2006
Wir sichern Ihren Erfolg.                      terreActive AG
-------------------------------------------------------------
