From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
Subject: Bug in iptables-save
Date: 25 Sep 2002 01:09:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032908982.4966.31.camel@Miraculinux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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

I have a little firewall-script which uses the mac-module.

I made this rule:

iptables -A INPUT -m mac --mac ! my:mac:ad:dr:ess -p tcp --dport 3306 -j
DROP

(I have substituted my real mac-addres with "my:mac:ad:dr:ess")

to block acces to my mysql-server from anywhere else than my machine.

It works. But when I try to use the iptables-save function that line
turns into=20
-A INPUT -m mac --mac !my:mac:ad:dr:ess -p -tcp --dport 3306 -j DROP

Note that the <space> between "!" and the mac-address is gone. The
result is that the reload of my iptables-ruleset stops with the error
message: "Bad mac address "!my:mac:ad:dr:ess"

I've experienced this with version 1.2.6a with a Mandrake 8.2 machine
and version 1.2.6a + 1.2.7a with Debian sarge/testing. (Haven't tried
version 1.2.7 with mandrake)


/Kristian Gr=F8nfeldt S=F8rensen
