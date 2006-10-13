From: Patrick McHardy <kaber@trash.net>
Subject: Re: nfq_set_verdict_mark
Date: Fri, 13 Oct 2006 08:15:41 +0200
Message-ID: <452F2F0D.1080502@trash.net>
References: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>	
	<4521284C.2070000@netfilter.org> <452B2D9A.7080702@trash.net>	
	<452C33FE.6060902@netfilter.org> <452CB33D.8060908@trash.net>	
	<452D6676.8090700@netfilter.org>
	<1160634939.24065.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Robert Scott <rbscott@cadvium.net>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1160634939.24065.8.camel@localhost>
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

Eric Leblond wrote:
> Le mercredi 11 octobre 2006 =E0 23:47 +0200, Pablo Neira Ayuso a =E9cri=
t :
>=20
>=20
>>We can warn about incompatibilities in the announce of new releases for
>>this kind of minor issues that we need to fix up and that result in
>>breakages, some kind of "heads up" section.
>=20
>=20
> Why not to add a API release number in the code.
>=20
> As developper of NuFW, I've got no problem to change my code but, I nee=
d
> a way to have my users not bored when they use my software. In fact I
> can not control which version of libnetfilter_queue.
>=20
> Something like "#define NFQUEUE_API_VERSION NNN" in libnetfilter_queue.=
h
> could really be used easily in application code to detect which flavour
> of the API they need to use.

That doesn't really solve the problem of incompatibilities. Any breakage
is really bad for a supposedly stable library. Pablo's suggestion about
adding new functions without breaking the old ones makes sense of
course, but there is no guarantee that we won't fuck up again. Which is
why I wanted to raise the question whether we want to continue this
way or go back to beta state until we're reasonable sure about the API.

Well, for now I guess the best way is to add the new functions and
go through a really long beta phase with the new API (after releasing
the current versions, which contain quite a few bugfixes since the
last release).
