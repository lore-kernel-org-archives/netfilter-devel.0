From: "MauroTablo'" <m.tablo@libero.it>
Subject: netfilter efficiency
Date: Thu, 20 Jan 2005 18:56:04 +0100
Message-ID: <005c01c4ff19$508ade80$c0de623e@MAURO>
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi all.
My Linux (+ iptables) based firewall has about 90 forward filtering =
rules, for tcp packets (about 30 rules), udp datagram (about 40 rules) =
and icmp messages(about 20 rules).
Suppose that it comes a transit tcp packet that doesn't match anyone of =
my rules. So, the last rule will be applied, because it is the first one =
that matches the packet (/sbin/iptables -A FORWARD -j DROP)

The question is: iptables confronts the TCP packet with all my 90 rules, =
or it confronts the packet ONLY WITH rules for tcp packets (-p tcp)?
In other words, is there a function in netfilter that looks up to the =
protocol type of a transit packet and decides which rules to confront =
the packet with?

Thank you.
Mauro.
