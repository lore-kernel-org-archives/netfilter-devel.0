From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: [PATCH] info file for ROUTE target
Date: Fri, 10 Dec 2004 10:03:25 +0100
Message-ID: <1102669404.11255.29.camel@descartes.info.ucl.ac.be>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
	<20041209195706.GA4121@oknodo.bof.de>  <41B8EB72.50502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@lists.netfilter.org"
	<netfilter-devel@lists.netfilter.org>, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41B8EB72.50502@trash.net>
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

Le ven 10/12/2004 =E0 01:18, Patrick McHardy a =E9crit :
> >I also made a new contribution, my --tee extension to ROUTE, which als=
o
> >went completely uncommented.
> >
> >https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/01=
7515.html
> >
> I'll apply this if Cedric is fine with it.

In fact, I advised Patrick (Schaaf) to collect reactions related to its
tee extension from this list. This is because --tee duplicates a packet,
which could cause DoS security problems if not used carefully.
Thanks to conntrack, we can avoid flooding ourself with duplicated
packets. My fear is that you could still have something like this :

          PC1                                    PC2

      orig packet    =20
           |
           v                  dup pkt 1
   [ROUTE --tee --gw PC2] -------------------------.
         | |   ^                                   |
         | |   |                                   v
         | |   '-----dup pkt 2 ---------- [ROUTE --tee --gw PC1]
         | |                                      | |
         v v                                      v v
 Flood of duplicated packets            Flood of duplicated packets

So we cannot make sure that people don't shoot themself. But anyway,
people using the ROUTE target are warned enough by pom...
Maybe I'm too paranoid ?

However, I think the --tee extension can really be useful. For example
to inspect pkt on other machine(s) and detect problems at line rate.

Since the ROUTE target is still an experimental target, my position is
to promote innovative (though sometimes risky) extensions. If the
extension introduces too many problems, I reserve the right to remove
it.

Thus, let's apply the patch ;)

Regards,

Cedric
