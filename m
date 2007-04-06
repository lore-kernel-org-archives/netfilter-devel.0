From: Dupond Jean <mootrul@yahoo.fr>
Subject: IETF RFC 4787 and NAT behaviour recommendations
Date: Fri, 6 Apr 2007 02:41:54 -0700 (PDT)
Message-ID: <839806.83249.qm@web51408.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
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

Hi,=0A=0A=0A=0AI saw new recommendation about NAT behaviour have been (or a=
re about to be) released :=0A=0Ahttp://tools.ietf.org/html/draft-ietf-behav=
e-tcp=0A=0Ahttp://tools.ietf.org/html/rfc4787=0A=0A=0A=0AI=0Amade a rapid t=
est that seems to show that actual version of=0Anetfilter/iptables with a b=
asic SNAT or MASQUERADE rule like this :=0A=0Aiptables -t nat -A POSTROUTIN=
G -o ppp0 -j MASQUERADE=0A=0Aimplement a "Address and port dependant fileri=
ng behaviour" (for UDP).=0A=0A=0A=0A(recommendation is Endpoint independent=
 or Address dependent filtering)=0A=0A=0A=0AIs it possible (how ?) to have =
a "Endpoint independent" for example ?=0A=0AIf not, is the netfilter develo=
ppement team generaly tending to try to be compliant with IETF recommendati=
ons ?=0A=0A=0ABest Regards,=0A=0A=0AJean=0A=0A=0A=0A=0A=0A=0A=09=0A=0A=09=
=0A=09=09=0A_______________________________________________________________=
____________ =0AD=E9couvrez une nouvelle fa=E7on d'obtenir des r=E9ponses =
=E0 toutes vos questions ! =0AProfitez des connaissances, des opinions et d=
es exp=E9riences des internautes sur Yahoo! Questions/R=E9ponses =0Ahttp://=
fr.answers.yahoo.com
