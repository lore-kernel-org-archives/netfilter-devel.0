From: Horms <horms@verge.net.au>
Subject: [SECURITY] DNAT'd host disclosure
Date: Thu, 2 Feb 2006 20:38:24 +0900
Message-ID: <20060202113824.GA4399@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wensong Zhang <wensong@linux-vs.org>, Roberto Nibali <ratz@drugphish.ch>,
	Moritz Muehlenhoff <jmm@inutil.org>,
	Micah Anderson <micah@riseup.net>, Julian Anastasov <ja@ssi.bg>,
	dann frazier <dannf@dannf.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I've put security in the topic of this message, but I want to make
it clear from the outset that I think this is a relatively minor
problem, so please don't get too excited about it.

Also, if these problems are well known, I'd appreciate pointers
to prior discussions, or at least a pointer to where to find
prior discussions.

Lastly, before I get into the actual problem, I apologise if
the CC list missed anyone it shouldn't have.


I have been researching the vulnerability of various kernel versions to
CVE-2002-0704, which is explained from various angles at:

  http://www.netfilter.org/security/2002-04-02-icmp-dnat.html
  http://rhn.redhat.com/errata/RHSA-2002-086.html
  http://www.securityfocus.com/bid/4699/discuss

In a nutshell, you can discover the internal IP address of a DNAT'd
host by manipulating the TTL of packets sent, such that the expire
between the DNATing and DNAT'd hosts.

  By DNATing host, I mean the machine that has the iptables DNAT rule
  By DNAT'd, I mean the host that the connection is directed to, which
  actually terminates the connection. So the packet path is:

  [end-user]----[some net]---[DNATing host]---[some more net]---[DNAT'd host]

  Sorry if this is confusing, I'm not sure what terms are usually used

I believe that this was resolved in 2.6.11 with the following patch
http://www.kernel.org/git/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=1e69ba3fa29b13fe5229d6e325aee91ae5abe298

At the very least, 2.6.16-rc2 does not seem to exhibit this problem,
while I have been able to reproduce it using 2.4.18, 2.4.27, 2.4.33-pre1
and 2.6.8. (I can reverify individual versions if need be).

In the course of playing with this for far to long I believe that I have
discovered two related vulnerabilities. 

I. Disclosure of intermediate hop addresses

I believe that the following patch, also included in 2.6.11 causes the
IP address of intermediate hops between the DNATing and DNAT'd hosts to
be trivially disclosed, as illustrated by the following tcptraceroute.

http://www.kernel.org/git/?p=linux/kernel/git/tglx/history.git;a=commit;h=8d5f3377d48c74df38990688f09e773887ba4eb5

# tcptraceroute 10.0.1.7 80
Selected device ppp7, address 10.0.1.4, port 1942 for outgoing packets
Tracing the path to 10.0.1.7 on TCP port 80 (www), 30 hops max
 1  10.0.1.7  26.517 ms  25.262 ms  74.672 ms
 2  192.168.1.254  76.070 ms  75.554 ms  75.988 ms
 3  10.0.1.7 [open]  69.503 ms  114.771 ms  105.756 ms

The client now knows not only that 10.0.1.7 80 is DNAT'd but that
there is an intermediate hop with the address 192.168.1.254. Which
is similar to the disclosure made by CVE-2002-0704, where the IP
address of hop 3 can be revealed using hbping (but not tcptraceroute).
The intermediate hop information can also be revealed using hbping,
and likely a variety of other tools.

I have a rather hackish patch, against today's Linus tree (~2.6.16-rc2)
at the bottom of this message, which conceals the address, leading to
the following output.

# tcptraceroute 10.0.1.7 80
Selected device ppp7, address 10.0.1.4, port 1952 for outgoing packets
Tracing the path to 10.0.1.7 on TCP port 80 (www), 30 hops max
 1  10.0.1.7  27.198 ms  72.374 ms  66.602 ms
 2  10.0.1.7  68.898 ms  76.121 ms  66.639 ms
 3  10.0.1.7 [open]  66.052 ms  107.855 ms  107.375 ms


II. DNAT use exposure

I believe that all versions of the DNAT code back to at least the
versions covered by CVE-2002-0704, and up to date allow TTL to be used
to ascertain if a port is DNAT'd. Looking at the original description of
CVE-2002-0704, and the two tcptracroutes above, it is easy to see that
the port has been DNAT'd. While the last trace does not disclose much
information, other than that DNAT is in use, and there are 2 hops after
the DNATing host, it is still unwanted disclosure. Imagine a user
whose ISP forbids the connection of networks, who is using DNAT (against
the ISP's policy), and the ISP runs a check like this.

I do not have a proposal to fix this problem. I'm actually not sure if
it is fixable. I would be interested to see what other DNAT
implementations do. And at the very least, I would like this message to
serve as documentation (or the start of documentation) of this problem.

This problem also seems to be exhibited in LVS. Although it only
discloses that DNAT (in the form of LVS-NAT) is in use, not how many
hops are taken, as only one additional hop is shown, regardless of how
many hops there actually hare. The tcptraceroute below was using an
LVS-NAT setup with 2 hops from the DNATing host to the DNAT'd host using
today's Linus tree (~2.6.16-rc2).

# tcptraceroute 10.0.1.7 80
Selected device ppp7, address 10.0.1.4, port 1973 for outgoing packets
Tracing the path to 10.0.1.7 on TCP port 80 (www), 30 hops max
 1  10.0.1.7  67.788 ms  71.196 ms  85.573 ms
 2  10.0.1.7 [open]  65.745 ms  105.648 ms  68.284 ms

I am one of the LVS maintainers, I have CCed the others, along with my
colleagues who look after security for the Debian Kernel.

Regards

-- 
Horms


diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index c1a6146..ed8e9bf 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -503,13 +503,15 @@ int ip_nat_icmp_reply_translation(struct
 	   CERT recommends dropping all packets from private IP
 	   addresses (although ICMP errors from internal links with
 	   such addresses are not too uncommon, as Alan Cox points
-	   out) */
-	if (manip != IP_NAT_MANIP_SRC
-	    || ((*pskb)->nh.iph->saddr == ct->tuplehash[dir].tuple.src.ip)) {
-		invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
-		if (!manip_pkt(0, pskb, 0, &target, manip))
-			return 0;
-	}
+	   out) 
+
+	   ... but the destination IP needs to be natted for all hosts
+	   else the address of hops between us and the NAT'd host
+	   can be exposed. Horms
+	   */
+	invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+	if (!manip_pkt(0, pskb, 0, &target, manip))
+		return 0;
 
 	return 1;
 }
