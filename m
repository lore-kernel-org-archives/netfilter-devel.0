From: "olivier" <odanes@free.fr>
Subject: forwarding one port to a port range with REDIRECT target
Date: Fri, 4 Mar 2005 17:02:22 +0100
Message-ID: <013c01c520d3$8d037710$1416a8c0@lannion.citypassenger.com>
Reply-To: olivier <odanes@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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

Hi all,

I would like to use the REDIRECT target to load balance incoming HTTP =
connections to a few couple of processes (not webservers).
for example incoming connections are received on port 8000 and forwarded =
to port 8080 and 8081 (or more).
I try the following rule:

iptables -t nat -A  PREROUTING -p tcp --dport 8000 -j REDIRECT =
--to-ports 8080-8081

the rule seems to be good according to the man page, but all the =
connections are forwarded to the same port (8080 in this example). I've =
tried different clients with odd and even IPs but nothing change.

How target port is selected, I've thought round-robin ... (no =
information found about selection algorithm) ?

a previous post seems to have the same problem but no suitables response =
was given... (see =
https://lists.netfilter.org/pipermail/netfilter/2004-January/049701.html)=


thanks for your help

NB: I'll do performances tests with httperf, and my stupid question is : =
is this method (processes load balancing with iptables) has through put =
limitations ?

my linux box is a redhat 9 :
# uname -a
Linux mowgli 2.4.20-8 #1 Thu Mar 13 17:18:24 EST 2003 i686 athlon i386 =
GNU/Linux
# iptables --version
iptables v1.2.7a
