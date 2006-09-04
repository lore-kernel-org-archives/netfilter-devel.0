From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Troubeleshooting  a  PPTP conversation
Date: Mon, 4 Sep 2006 10:46:33 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206FA78@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

> I didn't notice any error .. are there still gre connection tracking
entries when this error occurs?

Yes.  Searching for "1723" in the output I posted from
/proc/net/ip_conntrack, I see three entries.  The first two are from my
end user.  The third ons is from somewhere else - not sure where.
Curiously, all the IP Addresses on that third entry are internal.  I
wonder why anyone would do a PPTP connection when they are already part
of the network?  Here they are:

.
.
.
tcp      6 33 TIME_WAIT src=3D208.186.13.120 dst=3Daaa.bbb.212.154
sport=3D60462 dport=3D1723 packets=3D11 bytes=3D992 src=3D10.13.1.22 =
dst=3D208.18
6.13.120 sport=3D1723 dport=3D60462 packets=3D9 bytes=3D608 [ASSURED] =
mark=3D0
use=3D1
.
.
.
tcp      6 431997 ESTABLISHED src=3D208.186.13.120 dst=3Daaa.bbb.212.154
sport=3D60465 dport=3D1723 packets=3D8 bytes=3D856 src=3D10.13.1.22 =
dst=3D2
08.186.13.120 sport=3D1723 dport=3D60465 packets=3D7 bytes=3D512 =
[ASSURED]
mark=3D0 use=3D1
.
.
.
tcp      6 401883 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1723 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1723 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
.
.
.

It looks like everything in here shows TCP traffic.  I don't see
anything that mentions GRE specifically or protocol 47.  But that may be
normal. =20

I am guessing that the TIME_WAIT connection never goes away.  Then
another one comes in from the same IP Address and gets confused with the
TIME_WAIT one already in place.  But this only happens sometimes.  I am
still working on characterizing exactly what "sometimes" means. =20

By now it is several days later.  I will look and see if that TIME_WAIT
entry is still in place. =20

- Greg Scott



-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Monday, September 04, 2006 9:47 AM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org; Mike McRae
Subject: Re: Troubeleshooting a PPTP conversation

Greg Scott wrote:
> I sent this out last night but it never posted to the list.  This=20
> might be because the output from /proc/net/ip_conntrack was so huge. =20
> I will cut out the parts I don't think are relevant and try posting
this again.

I didn't notice any error .. are there still gre connection tracking
entries when this error occurs?
