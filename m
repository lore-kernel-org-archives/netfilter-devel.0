From: "Julio Kriger" <jkriger@cwazy.co.uk>
Subject: Can be done? reodering and delay SCTP packages?
Date: Thu, 24 Mar 2005 19:00:29 -0300 (ART)
Message-ID: <33837.200.127.126.201.1111701629.squirrel@200.127.126.201>
Reply-To: jkriger@hotpop.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hi!
I've developed some modifications to SCTP protocol on Linux kernel. Now I
want to test it. So here comes the problem.
I need to simulate reordending and random delay of SCTP packages between =
a
server and client application.
On the kernel there is implentation of sctp for iptables. Great! Also rea=
d
there is ip_queue or libipq which manage the package queue. Now, how can =
I
reorder the queue of packages? How can I do delay packages?
Thanks in advance.

Julio


PS: Hope this is the right maillits, sorry the bother if it's not.



--=20
-------------------------------
Julio Kriger
jkriger AT hotpop DOT com
jkriger AT cwazy DOT co DOT uk
