From: "Ariel Rosenblatt" <ariel@blueslice.com>
Subject: RE: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Tue, 15 Feb 2005 11:45:10 -0500
Message-ID: <009e01c5137d$b751fa90$320aa8c0@blueslicemtl>
References: <42121E8C.2070505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "'Patrick McHardy'" <kaber@trash.net>,
	"'Harald Welte'" <laforge@netfilter.org>
In-Reply-To: <42121E8C.2070505@trash.net>
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

Hello Patrick,

That is true, the conntrack must not change after the INIT_ACK is sent, =
and
as matter of fact once the endpoint sent the INIT_ACK it should do =
nothing
else to avoid DOS attacks; this until the 4-way cookie based handshake =
is
done and the TCB created. The COOKIE ECHO for an existing TCB case is
handled in 5.2.4, the special case I brought up is 5.2.4.A (Association
restart, 5.2.4.1).

The endpoint receiving the INIT_ACK is the "other" endpoint. So if the =
tag
was not properly saved when the INIT message left the originating =
endpoint
the INIT_ACK generated as a reply to the unexpected INIT will get =
dropped at
the INIT originating endpoint.

Note that the INIT_ACK is _NOT_ unexpected as the originating endpoint
previously sent an INIT (unexpected INIT_ACKs should always be =
discarded,
section 5.2.3), without the patch the INIT_ACK is being silently =
discarded.
The patch saves the initialization tag for the outgoing INIT, which will =
be
needed later to verify the incoming INIT_ACK. Without this a lost
association (e.g. power failure) can never be re-established before the
ESTABLISHED_TIMEOUT (currently set to 5 days) expires.

It is the destination endpoint that receives an unexpected INIT and it =
is
therefore bound to reply with an INIT_ACK, to get the 4-way handshake =
going
(section 5.2.2). However, as I mentioned above, the destination endpoint
shouldn't modify the existing association TCB or create a new one, =
otherwise
the destination endpoint will be vulnerable to DOS attacks.

I hope this makes sense...

Cheers,

- Ariel

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Tuesday, February 15, 2005 11:09 AM
To: Harald Welte
Cc: Ariel Rosenblatt; netfilter-devel@lists.netfilter.org
Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages droppedg

Harald Welte wrote:

>On Tue, Feb 08, 2005 at 07:37:22AM -0500, Ariel Rosenblatt wrote:
>
>>The following patch seems to solve the problem, the INIT "init_tag" is =
now
>>saved properly for an ESTABLISHED sctp association. The "init_tag" (of =
an
>>INIT message) wasn't being saved in the proper direction, causing the
>>INIT_ACK to be dropped while verifying the tag ("vtag") at the =
beginning
of
>>sctp_packet().
>>
>
>Thanks for your patch.  Patrick, would you please include the patch =
with
>your next patches to davem?
>
Are you sure it is correct ? RFC2960 =A75.2.2-5.2.4 talks about how to =
handle
unexpected INIT and INIT_ACKs. It says:

   After sending out the INIT ACK, the endpoint shall take no further
   actions, i.e., the existing association, including its current state,
   and the corresponding TCB MUST NOT be changed.

I sounds to me like we can translate this to "the conntrack must not
change".

Regards
Patrick
