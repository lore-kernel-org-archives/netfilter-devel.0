From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug in ipset -R
Date: Mon, 29 Aug 2005 08:55:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0508290842590.1135@blackhole.kfki.hu>
References: <Pine.LNX.4.62.0508190246520.6407@bizon.gios.gov.pl>
	<Pine.LNX.4.58.0508220940360.20621@blackhole.kfki.hu>
	<Pine.LNX.4.62.0508290045010.28187@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0508290045010.28187@bizon.gios.gov.pl>
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

On Mon, 29 Aug 2005, Krzysztof Oledzki wrote:

> On Mon, 22 Aug 2005, Jozsef Kadlecsik wrote:
> <CUT>
> > because the restore commands must follow each other in a rigid order (the
> > feature)
> Why? With "ipset -N ..."&"ipset -A ..." it is possible to use any
> order, I thought I can simply convert my scripts and use ipset -R feature.
> :(

Because thus it was not so hard to add save/restore functionality to
ipset. Patches are always welcomed to improve ipset!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
