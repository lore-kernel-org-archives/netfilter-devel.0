From: paridhi bansal <paridhibansal@yahoo.com>
Subject: Problem with ICMP NAT
Date: Wed, 5 Feb 2003 01:48:40 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030205094840.15787.qmail@web10806.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!!!

I am developing an application whereby i am
implementing NAT..I am using iptables..Using libipq i
am queuing the pkts. I am queueing the pkts at
following hooks:
Input
Prerouting
Postrouting
Output(nat)

Now my nat is working fine with TCP pkts..let's say
we have a situation like:
m/c A on LAN with ip say 172.10.1.12
m/c B that is doing NAT with ips 172.10.1.13 and
151.2.125.6
m/c C on Internet with Ip 151.2.125.78

Now A sends a TCP req to C..the request goes natted
and the return pkt comes at B's 151 interface, it nats
it back to m/c A's ip..This retuurn pkt enters
PREROUTING hook, then postrouing hook..All this is
working fine..

Problem is here:
If A sends an ICMP request to C, iCMP requst gets
natted so that it appears to come from B..Now C sends
back the ICMP reply to C..HOWEVER, this ICMP pkt does
not enter prerouting hook..it directly entrs INPUT
hook..so my application cannot do natting and m/c A
shows request timed out..

Can this problem be solved somehow?????Is it possible
to redirect a pkt from Input hook to some other
hook???

Regards,
Paridhi



__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
