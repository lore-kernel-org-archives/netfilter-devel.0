From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: only first TCP SYN packet consulted in nat table chains - bug
 or feature?
Date: Tue, 22 Jun 2004 15:43:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406221543000.2546-100000@blackhole.kfki.hu>
References: <1087911233.7536.2.camel@coati>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1087911233.7536.2.camel@coati>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 22 Jun 2004, Eric Leblond wrote:

> On Tue, 2004-06-22 at 15:19, Henrik Nordstrom wrote:
> > On Mon, 21 Jun 2004, Krzysztof Rusocki wrote:
> >
> > If you need to remember something related to a specific session between
> > packets then see the CONNMARK patch in pom-ng.
>
> This extension is one more time useful to someone. Does somebody know
> why it has not been included into the standard kernel ?

It was submitted into the 2.6 series long time ago.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
