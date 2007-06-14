From: "Fabrice Rafart" <fabrice.rafart@efs.sante.fr>
Subject: RE: Follow packets in rules
Date: Thu, 14 Jun 2007 09:55:59 +0200
Message-ID: <000801c7ae59$722cf5e0$1f06380a@adidf.efs.sante.fr>
References: <Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
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

Thanks for all your answers.

I can't use LOG destination or the packet/byes count :
  - LOG : I must double all my rules by a LOG rules : heavy and too =
verbose.
  - counter : My fw is in use, so I can't make difference between real
packet and the test one.

Netfilter had all the code to parse his rules, I think about a little =
hack
to give some parameter on a command line and print the matches on stdin.
But, there is a but ! I'm not a programmer.

Cordialement,
--=20
Fabrice Rafart
Administrateur syst=E8mes et r=E9seaux
Etablissement fran=E7ais du sang, Ile de France.
