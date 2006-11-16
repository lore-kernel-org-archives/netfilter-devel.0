From: frederic Lefrancois <fredericlefrancois@yahoo.fr>
Subject: Using libiptc to add firewall/nat rules
Date: Thu, 16 Nov 2006 09:46:54 +0000 (GMT)
Message-ID: <20061116094654.10366.qmail@web26814.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hello,=0A=0A=0A=0AI try to use the directly the libiptc to add firewall - n=
at rules in a little program.=0A=0AIt works perfectly with nat rules but I =
have troubles to add a simple firewall rules : when I call iptc_commit , I =
get an "No chain/target/match by that name" error.=0A=0AThe name of the cha=
in is FORWARD, target : IPTC_LABEL_ACCEPT and match : udp and the iptc_appe=
nd_entry works well.=0A=0A=0A=0ADoes anyone have an idea about this problem=
 and how to deal with ?=0A=0A=0A=0ASincerely=0A=0A=0A=0AFrederic L.=0A=0A=
=0A=0A=0A=0A=0A=0A=0A=0A=09=0A=0A=09=0A=09=09=0A___________________________=
________________________________________________ =0AD=E9couvrez une nouvell=
e fa=E7on d'obtenir des r=E9ponses =E0 toutes vos questions ! =0AProfitez d=
es connaissances, des opinions et des exp=E9riences des internautes sur Yah=
oo! Questions/R=E9ponses =0Ahttp://fr.answers.yahoo.com
