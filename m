From: "Alexandre Carlos" <alexandre@redes.unb.br>
Subject: iptables
Date: Mon, 18 Nov 2002 19:30:41 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <058d01c28f52$20836f10$1543a8c0@sanches>
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

Hi all

My experimental backbone is the following:

           67.91  4.2     4.3   1.3   1.1    10.1
             --------        ------       --------
 67.90- | ingress |----| core |----| egrees |-----10.2
             --------         -----        --------


I=B4m using IPTABLES version 1.2.4-dscp do set up the tos value of the
packets. I=B4m creating the following rule on the ingress and the egress
hosts.

iptables -A PREROUTING -t mangle -p icmp -j FTOS --set-ftos 0x28 or
iptables -A FORWARD -t mangle -p icmp -j FTOS --set-ftos 0x28

But when i try do ping from 67.90 to 10.2

The chechshum of the ip on the reply message is incorrect, so the packet =
is
droped on core hosts.

I would like to know, how can i avoid dropping the packet and still using
the same version of iptables and rules

Alex
