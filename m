From: Joerg Platte <lists@naasa.net>
Subject: Masquerading, IPSEC and bridged interfaces
Date: Mon, 30 Oct 2006 10:00:33 +0100
Message-ID: <200610301000.34289.lists@naasa.net>
Reply-To: jplatte@naasa.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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

Hi,

currently I'm using kernel 2.6.18.1 on one of my computers. The router ac=
ts as=20
an ipsec endpoint and masquerades all packets received via ipsec.

Today I replaced the local ethernet interface by a bridged interface by=20
combining the ethernet interface with a tap interface. I changed the=20
interface names in my iptables-based firewall to match the new bridge=20
interface name and did not change anything else.

Unfortunately, masquerading does not work with this setup. tcpdump reveal=
s,=20
that all received replies (I tested it with ping) are forwarded unencrypt=
ed,=20
because they are visible on my firewall instead of being encrypted. Is th=
is a=20
known problem, or did I forget to change anything? Or should I forward my=
=20
question to another list?

regards,
J=C3=B6rg

--=20
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605
