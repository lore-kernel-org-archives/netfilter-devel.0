From: "Wu Nick" <chundawu@hotmail.com>
Subject: iptables target conflict?  ROUTE and MASQUERADE
Date: Tue, 16 Dec 2003 08:55:23 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY13-F105p0oKHV3SF000296b7@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5; format=flowed
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

Hey guys:

Have you ever encounter the problem when using iptables target ROUTE and 
MASQUERADE?

We all know that MASQUERADE is used in IP-sharing mechanism to change the 
source 
IP adderss.  This is good when you have only one ppp connection.  However, 
I've 
got several pppoe connections at the same time to connect the Internet.  I 
dial 
up several pppoe connections at the same time, and I'm using ROUTE to 
redirect 
packets to different ppp interfaces.  But this will defeat the design of 
MASQUERADE. That is, I'd like to send packets out from different ppp 
interfaces 
and their source IP addresses needed to be changed to the IP addess of the 
specific ppp interface.  Do you have any idea about how to do?

>From the thread "[PATCH] update for ROUTE target in Netfilter-Extension 
HOWTO", 
it mentioned that once the ROUTE target applies for a packet, the packet is 

'stolen' and no further rues are consulted.  But in this way I have no 
chance to 
change my source IP address of the packet (just like MASQUERADE did) with 
the ip 
address of actual outgoing ppp interface.  I can't use MASQUERADE to change 
all 
packets' source IP a fixed ppp interface.  How can I do?  Any solution?

Nick

_________________________________________________________________
立即申請 MSN Mobile 服務：在您的手機上收發 MSN Hotmail 
http://msn.com.tw/msnmobile 
