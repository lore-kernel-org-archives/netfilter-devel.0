From: Jorge Matias Martin <jorge.matias@motorola.com>
Subject: Re: [PATCH] xt_sctp - add SCTP header size to IP header offset
Date: Mon, 19 Jun 2006 17:58:48 +0200
Message-ID: <200606191758.48909.jorge.matias@motorola.com>
References: <200606081754.09073.jorge.matias@motorola.com>
	<4496BA6A.3040308@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org
In-Reply-To: <4496BA6A.3040308@trash.net>
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

On 19 June  2006 16:53, Patrick McHardy wrote:
> Jorge Matias Martin wrote:
> > Hi, all.
> >
> > xt_sctp module is not working on 2.6.16 when --chunk-types option is
> > used. I have test this running sctp_darn and the following iptables
> > options:
> >
> > -A INPUT -p sctp --chunk-types any INIT -j DROP
> >
> > And this is the kernel log output:
> >
> > spt: 32822    dpt: 10105
> > Chunk num: 1  offset: 20      type: 128       length: 10105   flags: 36
> > skb->len: 92  offset: 10128
> > spt: 10105    dpt: 32822
> > Chunk num: 1  offset: 20      type: 39        length: 32822   flags: 79
> > skb->len: 284 offset: 32844
> > spt: 32822    dpt: 10105
> > Chunk num: 1  offset: 20      type: 128       length: 10105   flags: 36
> > ...
> >
> >
> > Note that length is actually the local port, and offset must be 32 (20
> > IPv4 header + 12 SCTP header).
> >
> > FYI, it works properly when --chunk-types is not used.
>
> Looks good too me. Please add a Signed-off-by: line so I can
> apply it. Thanks.

Signed-off-by: Jorge Matias <jorge.matias@motorola.com>

=2D----------

=2D-- linux-2.6.16.19/net/netfilter/xt_sctp.c.orig=A0=A0=A0=A0=A0=A0=A0=A02=
006-05-31=20
02:31:44.000000000 +0200
+++ linux-2.6.16.19/net/netfilter/xt_sctp.c=A0=A0=A0=A0=A02006-06-08 17:32:=
53.000000000=20
+0200
@@ -152,7 +152,7 @@ match(const struct sk_buff *skb,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&& SCCHECK(((ntohs(sh->dest=
) >=3D info->dpts[0])=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&& =
(ntohs(sh->dest) <=3D info->dpts[1])),=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0XT_=
SCTP_DEST_PORTS, info->flags, info->invflags)
=2D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&& SCCHECK(match_packet(skb=
, protoff,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&& SCCHECK(match_packet(skb, =
protoff + sizeof=20
(sctp_sctphdr_t),
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0info->chunkmap,=20
info->chunk_match_type,
=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0info->flag_info, info->flag_co=
unt,=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0hotdrop),
