From: "Ariel Rosenblatt" <ariel@blueslice.com>
Subject: RE: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Mon, 21 Feb 2005 13:33:09 -0500
Message-ID: <000e01c51843$d0a2e8e0$320aa8c0@blueslicemtl>
References: <42153BEE.7@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: 'Harald Welte' <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	'Kiran Kumar Immidi' <immidi@spymac.com>
To: "'Patrick McHardy'" <kaber@trash.net>
In-Reply-To: <42153BEE.7@trash.net>
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
> Sent: Thursday, February 17, 2005 7:51 PM
> To: Ariel Rosenblatt
> Cc: 'Harald Welte'; netfilter-devel@lists.netfilter.org; Kiran Kumar
> Immidi
> Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages dropped
>=20
> Ariel Rosenblatt wrote:
>=20
> >Hello Patrick,
> >
> >That is true, the conntrack must not change after the INIT_ACK is =
sent,
> and
> >as matter of fact once the endpoint sent the INIT_ACK it should do
> nothing
> >else to avoid DOS attacks; this until the 4-way cookie based =
handshake is
> >done and the TCB created. The COOKIE ECHO for an existing TCB case is
> >handled in 5.2.4, the special case I brought up is 5.2.4.A =
(Association
> >restart, 5.2.4.1).
> >
> >The endpoint receiving the INIT_ACK is the "other" endpoint. So if =
the
> tag
> >was not properly saved when the INIT message left the originating
> endpoint
> >the INIT_ACK generated as a reply to the unexpected INIT will get =
dropped
> at
> >the INIT originating endpoint.
> >
> >Note that the INIT_ACK is _NOT_ unexpected as the originating =
endpoint
> >previously sent an INIT (unexpected INIT_ACKs should always be =
discarded,
> >section 5.2.3), without the patch the INIT_ACK is being silently
> discarded.
> >The patch saves the initialization tag for the outgoing INIT, which =
will
> be
> >needed later to verify the incoming INIT_ACK. Without this a lost
> >association (e.g. power failure) can never be re-established before =
the
> >ESTABLISHED_TIMEOUT (currently set to 5 days) expires.
> >
> >It is the destination endpoint that receives an unexpected INIT and =
it is
> >therefore bound to reply with an INIT_ACK, to get the 4-way handshake
> going
> >(section 5.2.2). However, as I mentioned above, the destination =
endpoint
> >shouldn't modify the existing association TCB or create a new one,
> otherwise
> >the destination endpoint will be vulnerable to DOS attacks.
> >
> >
> As is conntrack if it modifies the saved tag of an established =
connection
> without looking for a valid exchange of Tie-Tags and COOKIE-ECHO, if I
> don't
> completely misunderstand. Someone simply needs to send an INIT for an
> existing
> association and can prevent further packets from getting through. But =
I
> think
> you're patch is what is intended by the code, so we probably should =
put
> it in
> for now. Kiran, could you have a look at Ariel's patch please ?
>=20

You are right about the conntrack being susceptible to fraudulent INIT
messages. This holds true for INIT-ACKs as well as the first INIT send.=20

Saving the verification tags harms more than it helps, because it makes =
the
connection tracking vulnerable to dos attacks. While the goal is dumping
invalid traffic, it could instead wind up discarding valid traffic.=20

I thought about these issues and I don't see a way of using verification
tags without making the connection tracking susceptible to this =
problems.
Saving tie-tags for existing associations until the COOKIE-ECHO/ACK is
processed could alleviate the problem. However, it will still take one
fraudulent message to launch an attack and cause the module to discard =
valid
traffic or prevent the association from being established by overwriting =
the
valid tie-tag.=20

And then again, SCTP is just a transport protocol and without =
authentication
(e.g. IPSEC AH), it will be vulnerable to masquerading attacks as well, =
so
maybe SCTP connection tracking doesn't really have to protect against =
these,
as IPSEC would provide the needed authentication and prevent malicious
messages from overwriting the connection tracking saved verification =
tags.
This is good, because we can leave things as they are and just patch the
code for the re-starting association case.

In the mean time I patched the module with the code below (please see a =
more
robust patch at the end of the message) to solve the saved vtag problem =
for
both directions.

Thanks,

- Ariel

> Thanks,
> Patrick
>=20

--- /usr/src/linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
2005-02-04 16:22:24.000000000 -0500
+++ ip_conntrack_proto_sctp.c   2005-02-21 13:06:58.373096368 -0500
@@ -392,6 +392,7 @@
                if (sch->type =3D=3D SCTP_CID_INIT=20
                        || sch->type =3D=3D SCTP_CID_INIT_ACK) {
                        sctp_inithdr_t _inithdr, *ih;
+                       u_int32_t dir;
=20
                        ih =3D skb_header_pointer(skb, offset +
sizeof(sctp_chunkhdr_t),
                                                sizeof(_inithdr),
&_inithdr);
@@ -401,7 +402,9 @@
                        }
                        DEBUGP("Setting vtag %x for dir %d\n",=20
                                        ih->init_tag, =
CTINFO2DIR(ctinfo));
-                       conntrack->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] =
=3D
ih->init_tag;
+                       dir =3D (CTINFO2DIR(ctinfo) =3D=3D =
IP_CT_DIR_ORIGINAL)?=20
+                           IP_CT_DIR_REPLY: IP_CT_DIR_ORIGINAL;
+                       conntrack->proto.sctp.vtag[dir] =3D =
ih->init_tag;
                }
=20
                conntrack->proto.sctp.state =3D newconntrack;
