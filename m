From: "Fabrice Rafart" <fabrice.rafart@efs.sante.fr>
Subject: Follow packets in rules
Date: Tue, 12 Jun 2007 20:08:00 +0200
Message-ID: <000001c7ad1c$9ccb09b0$1806380a@adidf.efs.sante.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello,

I look for a tool to follow a packets into rules of netfilter.

For example :

# iptables-test -s 192.168.1.1 -d 192.168.2.1 -p tcp --dport 25
--> FORWARD line 1  : -p tcp --dport 25 -j SMTP
--> SMTP line 3     : -s 192.168.1.0/24 -j DROP

This show me which rules matches the packet until the end.

Does this exist ?

Thank and sorry for my poor english.

Cordialement,
--=20
Fabrice Rafart
Administrateur syst=E8mes et r=E9seaux
Etablissement fran=E7ais du sang, Ile de France.
