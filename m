From: "Alexandre Carlos" <alexandre@redes.unb.br>
Subject: iptables 1.2.6a
Date: Thu, 10 Oct 2002 18:34:38 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <046301c270a4$d62e9640$1543a8c0@sanches>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

i want to add a rule to the iptable as follow

iptables -t nat -A PREROUTONG -s 10.1.1.2 -d 192.168.67.91 -p tcp -dport
23 -j DNAT --to-destination 192.168.1.1

but i=B4m receiving the following error message multiple -d flags not all=
owed.

I usind RH 7.2 iptables 1.2.6a, and i want to know how can i fix this? Do=
 i
have to change the iptables version? Is this a common error message?

[]s

Alex
