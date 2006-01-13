From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Problem with NetBIOS name service protocol support in 2.6.15
Date: Fri, 13 Jan 2006 14:57:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0601131444030.9316@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-966554373-1137160654=:9316"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-966554373-1137160654=:9316
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

I have just upgraded one of my servers to 2.6.15 and noticed that=20
computser are no longer able to browse "Network Neighbourhood".

Packets sended by workstations (for example 192.168.0.3) to the broadcast=
=20
address were ignored:

14:31:56.027354 IP 192.168.0.3.138 > 192.168.0.255.138: NBT UDP PACKET(138)
14:31:58.027459 IP 192.168.0.3.138 > 192.168.0.255.138: NBT UDP PACKET(138)
14:31:58.027584 IP 192.168.0.3.138 > 192.168.0.255.138: NBT UDP PACKET(138)

What is strange that I solved this problem by recompiling and booting=20
kernel without ip_conntrack_netbios_ns enabled. Now everything works=20
fine. I thought that it should only handle UDP packets to port 137...

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-966554373-1137160654=:9316--
