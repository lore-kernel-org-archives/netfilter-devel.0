From: Eric Leblond <eric@inl.fr>
Subject: Re: conntrack: Connection close event?
Date: Wed, 22 Aug 2007 23:48:31 +0200
Message-ID: <1187819311.4824.4.camel@ghlodit.inl.fr>
References: <004501c7e4e6$74509e80$1700a8c0@xcony13>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Cedrix <netfilter@cedrix.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <004501c7e4e6$74509e80$1700a8c0@xcony13>
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

Le mercredi 22 ao=C3=BBt 2007 =C3=A0 20:01 +0200, Cedrix a =C3=A9crit :
> Hi,
>=20
> this is my first request. I checked google, nf-faqs and conntrack-homepag=
e=20
> without sufficient results for this problem:
>=20
> In Short: I need to know when a connection (TCP or UDP) gets closed. I wa=
nt=20
> to use conntrack, because I can track UDP more easily.

The result of "conntrack -E -e DESTROY" is what you want. You can thus
look at the code to build what you want.

You can also look at NuFW (http://www.nufw.org/) which handle conntrack
destroy event. The concerned source code is browsable here:
http://software.inl.fr/trac/trac.cgi/browser/mirror/edenwall/nufw/trunk/nuf=
w/src/nufw/conntrack.c

Hope this help,
--
Eric Leblond
