From: "Lars Lockenvitz" <L.Locke@web.de>
Subject: pc stand still after using module
Date: Mon, 13 Sep 2004 10:29:18 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1470957170@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I have a modules for connection tracking of clearcase packets.
After adjustment from kernel 2.4.27 to 2.6.8 my pc is standing still after=
 using this module.
The only things I changed are the pameters of the help function.

From:
static int help (const struct iphdr *iph, size=5Ft len,
                        struct ip=5Fconntrack *ct, enum ip=5Fconntrack into ct=
info)

To:
static int help (struct sk=5Fbuff *skb, struct ip=5Fconntrack *ct, enum ip=5Fcon=
ntrack=5Finfo ctinfo)

Now the modules works, but then the pc doesn=B4t  recognizes anything.


Does anybody have a similar problem and know how to solve it, or have anyb=
ody else any idea.
Please help me, please!!!

Regards

Lars
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
WEB.DE Video-Mail - Sagen Sie mehr mit bewegten Bildern
Informationen unter: http://freemail.web.de/=3Fmc=3D021199
