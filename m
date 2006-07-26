From: Thomas Heinz <thomasheinz@gmx.net>
Subject: Ipsec, policy match and PROTO=4
Date: Thu, 27 Jul 2006 01:31:18 +0200
Message-ID: <200607270131.18655.thomasheinz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Hello guys

I have the following standard ipsec tunnel:

[tun_A] host_A [pub_A]-------------[pub_B] host_B [tun_B]

pub_A/B: public IP of host_A/B
tun_A/B: tunnel IP of host_A/B

After establishing the ipsec connection, putting two simple log-all rules 
in INPUT and OUTPUT like this:
# iptables -I INPUT -j LOG
# iptables -I OUTPUT -j LOG
and pinging tun_B from host_A, I get the following log entries:

IN= OUT=eth0 SRC=tun_A DST=tun_B LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF 
PROTO=ICMP TYPE=8 CODE=0 ID=16181 SEQ=1
IN= OUT=eth0 SRC=pub_A DST=pub_B LEN=136 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF 
PROTO=ESP SPI=0xxxxxxxxx

Very nice so far: the packet is seen twice, once clear and once encrypted. 
Now, let's look at the ICMP reply.

IN=eth0 OUT= MAC=xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx SRC=pub_B 
DST=pub_A LEN=136 TOS=0x00 PREC=0x00 TTL=56 ID=57843 PROTO=ESP 
SPI=0xxxxxxxxx
IN=eth0 OUT= MAC=xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx SRC=pub_B 
DST=pub_A LEN=104 TOS=0x00 PREC=0x00 TTL=56 ID=57843 PROTO=4

Here, we see the packet also twice but the cleartext one has PROTO=4 
(ipencap, ipip tunnel).

This has been observed in e.g. this thread: 
http://marc.theaimsgroup.com/?l=netfilter-devel&m=114010374229806&w=2

Moreover, I have previously sent this posting to the netfilter user mailing 
list.

Could you please tell me about the current state regarding this bug? Is it 
already addressed? Is it hard to fix? 

Is it correct that there is currently no way to filter incoming clear text 
packets? Accepting PROTO=4 packets of course works but it is rather a 
workaround.

Thanks for your support.


Best regards,

Thomas
