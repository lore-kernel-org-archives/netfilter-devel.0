From: Nils Ohlmeier <lists@ohlmeier.de>
Subject: conntrack manipulation
Date: Thu, 8 May 2003 23:47:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305082347.41709.lists@ohlmeier.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

short question: is it possible to manipulate the entrys of the connection 
tracking (specialy adding and removing entrys) from user space?

In more details:
we try to get an over SIP signaled RTP stream (Voice over IP) through 
netfilter NAT. Some time ago we coded the fcpd (http://fcpd.berlios.de) which 
enables applications to maipulate packet filter and NAT rules. Now the SIP 
Express Router (http://www.iptel.org/ser) has support for this netfilter 
manipulation. But after long testing sessions we came to the following 
result:

phone1 ------ NAT ------- Internet ----- phone2

Phone1 starts a call to phone2 (INVITE message). Phone2 confirms the call (200 
OK message) after the user picked up and starts to send RTP packets to the 
public NAT address immediately. Now the comfirmation message hits the SIP 
proxy at the NAT box and will be processed. The proxy requests at the fcpd to 
insert S- and D-NAT rules for the RTP stream. The fpcd processes the request 
and inserts the rules.
But during all this process time the first RTP packets allready hit the NAT 
box. And if this packets are not droped by a rule, they will create a new 
conntrack entry. Now the insertion of the S/DNAT rules comes too late because 
all the packets of the stream will be intercepted by the conntrack before 
they hit our new rules.
Ok if the NAT box drops every packet which is not explictly allowed everything 
should work fine. But i think this is somewhat unrealistic, because most NATs 
will at least accept all packets from the private side to the Internet.

So my question is if it is possible that the fcpd deletes connection tracking 
entrys from the early packets. And if the fcpd could just insert a connection 
tracking entry for the stream it could omit the insertion of three normal 
rules (SNAT, DNAT and FORWARD).

I know that i could explicitly drop the packets from the stream until the 
connection is confirmed. But i dont like this idea because it complicates the 
rule handling from the fcpd a much. And because of the details in the SIP 
protocol we could only drop packets with some wildcards in the matching 
rules.

Thanks for any comments and ideas.
Greetings
  Nils Ohlmeier
