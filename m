From: "Ariel Rosenblatt" <ariel@blueslice.com>
Subject: RE: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Tue, 22 Feb 2005 11:34:00 -0500
Message-ID: <002f01c518fc$510cb660$320aa8c0@blueslicemtl>
References: <421B3C42.2060106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: 'Harald Welte' <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	'Kiran Kumar Immidi' <immidi@spymac.com>
To: "'Patrick McHardy'" <kaber@trash.net>
In-Reply-To: <421B3C42.2060106@trash.net>
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



> -----Original Message-----
> From: Patrick McHardy [mailto:kaber@trash.net]
> Sent: Tuesday, February 22, 2005 9:06 AM
> To: Ariel Rosenblatt
> Cc: 'Harald Welte'; netfilter-devel@lists.netfilter.org; 'Kiran Kumar
> Immidi'
> Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages dropped
>=20
> Ariel Rosenblatt wrote:
> > I thought about these issues and I don't see a way of using =
verification
> > tags without making the connection tracking susceptible to this
> problems.
> > Saving tie-tags for existing associations until the COOKIE-ECHO/ACK =
is
> > processed could alleviate the problem. However, it will still take =
one
> 	> fraudulent message to launch an attack and cause the module to
> discard valid
> > traffic or prevent the association from being established by =
overwriting
> the
> > valid tie-tag.
>=20
> How can it be attacked with a single message ? I'm thinking of =
something
> like this (based on RFC 2960 5.2.4.1):
>=20
> Endpoint A                                          Endpoint Z
> <-------------- Association is established---------------------->
> Tag=3DTag_A                                             Tag=3DTag_Z
> <--------------------------------------------------------------->
> {A crashes and restarts}
> {app sets up a association with Z}
> (build TCB)
> INIT [I-Tag=3DTag_A'
>        & other info]  --------\ <- conntrack lets this packet pass
> (Start T1-init timer)         \
> (Enter COOKIE-WAIT state)      \---> (find a existing TCB
>                                        compose temp TCB and Cookie_Z
>                                        with Tie-Tags to previous
>                                        association)
>                                  /--- INIT ACK [Veri Tag=3DTag_A',
>                                 /               I-Tag=3DTag_Z',
> (Cancel T1-init timer) <------/                Cookie_Z[TieTags=3D
>                                                 Tag_A,Tag_Z
>                                                  & other info]
>                                       (destroy temp TCB,leave original
>                                        in place)
>=20
> Conntrack notes the Tie-Tags if they match the used tags and
> lets this message pass.
>=20
> COOKIE ECHO [Veri=3DTag_Z',
>               Cookie_Z
>               Tie=3DTag_A,
>               Tag_Z]----------\
> (Start T1-init timer)         \
> (Enter COOKIE-ECHOED state)    \---> (Find existing association,
>                                        Tie-Tags match old tags,
>                                        Tags do not match i.e.
>                                        case X X M M above,
>                                        Announce Restart to ULP
>                                        and reset association).
>=20
> Conntrack verifies the tags match the saved tags and resets the
> association.
>=20
> So without a full exchange no data is changed.
>=20

Hi Patrick,

This is kind of what I had in mind. However, a malicious INIT-ACK, with
knowledge about the saved tags (these can be easily sniffed) can cause =
the
conntrack module to save a fictitious Tag_Z'' causing the conntrack to =
save
Tag_A' and Tag_Z'', thus discarding the valid INIT-ACK with =
Init_Tag=3DTag_Z'.

Also, a malicious COOKIE-ECHO can cause the Tag_Z''' to be saved instead =
of
Tag_Z', having the same effect as a malicious INIT-ACK.=20

As for saving Tag_A', this can be done at the INIT or the INIT-ACK. =
Saving
it at the INIT is bad as you mentioned before. Saving it during the =
INIT-ACK
is also bad because a malicious INIT-ACK can make Tag_A'' to be saved
causing the conntrack module to discard valid traffic tagged as Tag_A'.

It would seem that by keeping the Tag_A' used in the INIT (while Tag_A =
is
still in use) just to match it to the Tag_A' that should be used in the
INIT-ACK will solve the problem (kind of a two staged approach). However
this "kept" Tag_A' (or Tag_Z' for the INIT-ACK) can be easily =
overwritten
with a malicious INIT (or INIT-ACK), before the INIT-ACK arrives (or the
COOKIE-ECHO is sent). Timers will help for this two phase approach. =
However,
serious performance degradation will still be achieved if the vtags and
tie-tags are known to the attacker.

Tags (as well as cookies) can be sniffed, so malicious cookies can be
generated to trick the connection tracking into believing that the
association must be reset. The very fact that the connection tracking =
relies
on these messages to save the tags is what causes this vulnerability.

However, as I stated before, without proper network layer authentication
(e.g. IPSEC AH) SCTP endpoints are not exempt from masquerading attacks, =
and
there is so much connection tracking can do to enhance the lack of =
transport
layer security.=20

Thanks,

- Ariel=20

> Regards
> Patrick
