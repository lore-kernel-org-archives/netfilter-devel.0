From: Chris Larson <kergoth@gmail.com>
Subject: Re: latest ctnetlink for Linux 2.4.XX?
Date: Wed, 14 Sep 2005 10:23:28 -0500
Message-ID: <b6ebd0a50509140823314e643b@mail.gmail.com>
References: <200509131654.j8DGs07L008682@server.ezpacket.com>
Reply-To: kergoth@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: CK Wang <ck@ezpacket.com>
In-Reply-To: <200509131654.j8DGs07L008682@server.ezpacket.com>
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

On 9/13/05, CK Wang <ck@ezpacket.com> wrote:
>=20
> - I found nfnetlink-conntrack-0.13 is deprecated in pom-ng. But, it's a
> starting point for me to work on my Linux 2.4.30 kernel.
>=20
> - However, after done with the patch intergration with Linux 2.4.30. I
> couldn't find a compatible libnfnetlink and libctnetlink to work with
> nfnetlink-conntrack-0.13. Current libnfnetlink and libctnetlink(or
> libnfnetlink-conntrack) are rewritten for Linux 2.6.


I ran into this as well not long ago, so I looked into the svn repository,=
=20
and checked out the revision of the libnfnetlink library from back before=
=20
the rename / repository reorg (libctnetlink became libnfnetlink_conntrack).=
=20
That one appears to work fine. libctnetlink, however, does not seem to. I=
=20
dug up an old copy of the 'ct' test tool and enhanced it to meet my needs.

--
Chris Larson
kergoth@handhelds.org
