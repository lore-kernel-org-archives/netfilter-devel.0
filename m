From: =?iso-8859-1?Q?KUCKAERTZ_R=E9gis_-_NVISION?= <regis@nvision.lu>
Subject: Port forwarding with iptables
Date: Wed, 1 Sep 2004 17:47:49 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <E1C2j6E-0002HL-00@deer.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Our ISP only allows connections coming from a well-defined list of IP
addresses. Since we must be able to log on to our servers no matter =
where we
are, I just thought using iptables on one host having one of the =
authorized
IP addresses would be the solution.

So I went on reading iptables docs and howtos, but as you might guess I
couldn't stand how to do it exactly. Let's put it correctly stated: =
every
incoming connection to, say, port 3999 of my host ($HOST_IP) should be
forwarded to port 123 of the protected server ($SERVER_IP). I tried the
following two rules:

$IPTABLES -t nat -A PREROUTING -p tcp --dst $HOST_IP --dport 3999 -j =
DNAT
--to-destination $SERVER_IP:123

   This one should do the forwarding

$IPTABLES -t nat -a POSTROUTING -p tcp --dst $SERVER_IP --dport 123 -j
MASQUERADE

   ... and this one should masquerade

As I'm new to iptables, I don't know at that time every aspect that I =
must
be careful of, so as a first tip can anybody tell me what would the =
exact
solution be?

I have set IP forwarding to 1 in /proc/sys/net/ipv4/ip_forward

Best regards,
R=E9gis KUCKAERTZ
-----------------------------------------
NVISION sa - Luxembourg
Internet Services & Network Programming

50, rue des Pr=E9s
L-7333 Steinsel
T=E9l: (+352) 26 34 09 08
Fax: (+352) 26 34 09 07
http://www.nvision.lu/
