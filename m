From: "Rajesh B. V." <rajeshbv@intotoinc.com>
Subject: Problem with MASQUERADE of L2TP packets
Date: Thu, 13 Nov 2003 16:32:55 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
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

Hi All,

We have our L2TP module which now we are integrating with Linux IPtables. 
We are facing problem in sending data through L2TP session.

SG1 in following setup is having iptables with MASQUERADE. The rule is:

# iptables -t nat -A POSTROUTING -j MASQUERADE -o ppp0

Test set-up:

192.168.1.82 192.168.1.254
LAN PC ----------------- SG 1 ( LAC Mode ) --------------- SG2 ( LNS Mode )
172.16.3.83 172.16.3.73
6.6.6.7 ---- l2tp tunnel ---- 6.6.6.6

After estabilshing the L2TP tunnel, when we issue ping from LAN PC 
(192.168.1.82) to LNS IP address (6.6.6.6) we observe the packets sent out 
by SG1 having strange Source IP in both inner and outer IP header.
# ping 6.6.6.6 (from 192.168.1.82)

Problem:
The outer IP header is having the source IP as 6.7.1.254 (last two octets 
of PPP IP + last two octets of ethernet IP).
And the inner IP header (PPP) is having source as 6.6.6.7 instead of 
192.168.1.82 (actual packet originator).

If i disable the iptables rule with MASQUERADE then the traffic is going fine.

We are calling " ip_finish_output () " in our L2TP send function. Till this 
function the IP headers are intact and fine. IP tables hook function will 
be called in " ip_finish_output ()", where NAT is applied and the problem 
could be in this area.

Can anyone suggest, what is the mistake in configuration or is it the 
problem with L2TP itself ?

PS:
Pl. reply me as i did not subscribe to the list.

Regards,
--Rajesh
