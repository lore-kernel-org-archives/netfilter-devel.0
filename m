From: "Preston A. Elder" <prez@srealm.net.au>
Subject: [Fwd: Re: [netfilter-core] iptables/conntrack in enterprise
	environment.]
Date: 04 Jun 2003 16:18:52 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054757932.9533.29.camel@clueless>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-bX/gbDZU9hi+uCVI7wMS"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-bX/gbDZU9hi+uCVI7wMS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

While waiting for a response to the email I sent below, I went ahead and
investigated the 3rd 'question' I raised in that email.

I essentially removed the checking of ip_nat_used_tuple for DNAT (which
appplies to REDIRECT entries too) entries.

I changed this code in get_unique_tuple (ip_nat_core.c) from this:
                if ((!(rptr->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
                     || proto->in_range(tuple, HOOK2MANIP(hooknum),
                                        &rptr->min, &rptr->max))
                    && !ip_nat_used_tuple(tuple, conntrack)) {
                        ret = 1;
                        goto clear_fulls;
                } else {

to this:
                if ((!(rptr->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
                     || proto->in_range(tuple, HOOK2MANIP(hooknum),
                                        &rptr->min, &rptr->max))
                    && (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST ? 1 :
!ip_nat_used_tuple(tuple, conntrack))) {
                        ret = 1;
                        goto clear_fulls;
                } else {

I commented out the ASSERT's just after the proto->unique_tuple calls in
get_unique_tuple (ip_nat_core.c) aswell, the lines that look like this:
                                        IP_NF_ASSERT(!ip_nat_used_tuple
                                                     (tuple,
conntrack));


And changed this code in tcp_unique_tuple (ip_nat_proto_tcp.c) from
this:
        for (i = 0; i < range_size; i++, port++) {
                *portptr = htons(min + port % range_size);
                if (!ip_nat_used_tuple(tuple, conntrack)) {
                        return 1;
                }
        }

to this:
        if (maniptype == IP_NAT_MANIP_DST)
        {
                *portptr = htons(min + net_random() % range_size);
                return 1;
        }
        else
        {
                start = net_random() % range_size;
                port += start;
                                                                                    
                for (i = start; i < range_size; i++, port++) {
                        *portptr = htons(min + port % range_size);
                        if (!ip_nat_used_tuple(tuple, conntrack)) {
                                return 1;
                        }
                }
                if (i == range_size)
                {
                        port -= range_size;
                        for (i = 0; i < start; i++, port++) {
                                *portptr = htons(min + port %
range_size);
                                if (!ip_nat_used_tuple(tuple,
conntrack)) {
                                        return 1;
                                }
                        }
                }
        }

I only have one rule in the entire NAT table, the one that forwards all
new connections to ports for machines behind it to a specific port range
on the local machine (which is in the PREROUTING 'chain').

This change DOES seem to have the desired effect, of making connections
fully establish pretty much immediately, and as suspected, since the
socket on the local machine is just a listening socket, it really does
not care about multiple connections, and thus does not need the 'in use'
checking above.  However, after putting this in place, the system seems
to stop functioning (I'm not sure if its just the network, or the system
itself, since I'm not at the console, however I suspect its the system
itself, as its a very sudden freeze).

Could someone shed some light into why the system would freeze after a
short period of time (less than 5 minutes) with this code running (note:
it only freezes when our application is running, ie. there is something
there to accept connections).  And also possibly shed some light on
possible side-effects the above modifications could have (apart from
freezing the system)?  I don't usually screw around with the kernel
(though I have before), so this is relatively new territory for me.

Any and all help, comments, etc. appreciated.

Thanks,

PreZ :)

--=-bX/gbDZU9hi+uCVI7wMS
Content-Disposition: inline
Content-Description: Forwarded message - Re: [netfilter-core]
	iptables/conntrack in enterprise environment.
Content-Type: message/rfc822

From: "Preston A. Elder" <prez@srealm.net.au>
Organization: Shadow Realm
X-KMail-Identity: 1534576354
To: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 20:55:25 -0400
User-Agent: KMail/1.5.2
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
References: <200305290113.58552.prez@srealm.net.au>
	 <200305300133.44822.prez@srealm.net.au>
	 <20030530194240.GI29312@sunbeam.de.gnumonks.org>
In-Reply-To: <20030530194240.GI29312@sunbeam.de.gnumonks.org>
X-KMail-Link-Message: 2030304710
X-KMail-Link-Type: reply
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: clearsigned data
Content-Disposition: inline
Message-Id: <200305302055.40839.prez@srealm.net.au>
X-KMail-EncryptionState: N
X-KMail-SignatureState: F
Content-Type: text/plain; CHARSET=iso-8859-1

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Friday 30 May 2003 03:42 pm, Harald Welte wrote:
> > If I then telnet to 10.0.0.1 on port 5050, the connection is immediate,
> > and my application receives a new connection on port 5050.  If, however=
,
> > I telnet to 10.0.0.1 on port 5150, there is a small (but noticable) del=
ay
> > between when the telnet session shows the connection as established, an=
d
> > when the application receives the connection (on a random port between
> > 5000 and 5100 inclusive).
>
> This is _definitely_ not a netfilter issue then.  We are not doing
> transparent proxying but nat.  netfilter/iptables _never_ accept
> connections on their own.  So you open a connection:
Maybe not, but thats the behavior I'm seeing.  But this doesnt bother me so=
=20
much as it takes a LOT longer for a connection to be established when=20
connecing to a port outside the range, than to one inside the range.


> 1. telnet 10.0.0.1 5150
> 2. syn packet is sent by telnet
> 3. syn packet is DNAT'ed by netfilter
> 4. syn packet arrives at server application
> 5. syn/ack packet is sent by server application
> 6. syn/ack packet is SNAT'ed by netfilter
> 7. syn/ack packet is received by telnet
>  [further handshake goes on]
> x. telnet application prints 'Connection established' (connect(2) call
>    returns)
>
> This is a fundamental tcp/ip operation, and it can certainly by no way
> be anything that netfilter does, that would introduce a behaviour like
>
> 1. telnet 10.0.01 5150
> 2. telnet shows 'connection established'
> 3. connection 'arrives' at server
>
> [which is what you have been describing, If I understood you correctly].
I realise this is supposed to happen, however again, its not what I'm=20
observing, though its only noticable under high loads, so maybe its taking =
a=20
long time to get the initial SYN and ACK to the server from telnet (which=20
would account for both the delay before connection is established by telnet=
=20
(delay for SYN/ACK to get back from server), and the delay between this and=
=20
the server showing the connection established (which only happens after it=20
gets the ACK).

OK, so with this information, its taking a LONG time to get the SYN and ACK=
 to=20
the server when I'm connecting to a port outside the range I'm listening on=
=20
with the application, causing the appearance of the port being connected by=
=20
telnet a long time before the server shows it being established.  In any=20
case, this doesnt change the problem.  This delay does *NOT* exist when=20
connecting to a port that is in the listening range (remember that all=20
connections being discussed here are going to systems BEHIND the router box=
).

I did some kernel diving, I've iscolated the place where the behavior=20
differentiates between a connection 'in' and 'out' of the port range, at th=
is=20
if statement in get_unique_tuple (ip_nat_core.c):
               if ((!(rptr->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
                     || proto->in_range(tuple, HOOK2MANIP(hooknum),
                                        &rptr->min, &rptr->max))
                    && !ip_nat_used_tuple(tuple, conntrack)) {

Obviously, anything connecting to a port outside this range will fail the=20
above if.  If this fails, it will lead us to do this (one way or another):
                       if (proto->unique_tuple(tuple, rptr,
                                                HOOK2MANIP(hooknum),
                                                conntrack)) {

The unique_tuple function is where the delay is.  In this case, its a TCP=20
connection, which translates to tcp_unique_tuple (ip_nat_proto_tcp.c), whic=
h=20
after determining the port range, does the following:
        for (i =3D 0; i < range_size; i++, port++) {
                *portptr =3D htons(min + port % range_size);
                if (!ip_nat_used_tuple(tuple, conntrack)) {
                        return 1;
                }
        }

Now I'm assuming it will use this:
                min =3D ntohs(range->min.tcp.port);
                range_size =3D ntohs(range->max.tcp.port) - min + 1;
rather than this:
                        min =3D 1024;
                        range_size =3D 65535 - 1024 + 1;
for my port range, since I specified a local port range, however either way=
,=20
the range is about 100 ports.  Which means the above nat used lookup happen=
s=20
100 times (as opposed to once for when the port is inside the range).  And=20
since ip_nat_used_tuple (ip_nat_core.c) calls ip_conntrack_tuple_taken=20
(ip_conntrack_core.c), which subsequently locks/unlocks the entire conntrac=
k=20
table, and calls __ip_conntrack_find (which is a list lookup!), the above f=
or=20
loop is a very intensive process.

Now, after all that.  A few questions arise:
1) Is there a way the above for loop could lock the conntrack table=20
beforehand, do the searches (not locked) and unlock afterwards.  This is=20
probably the biggest thing consuming all the speed, constant=20
locking/unlocking, especially when there are many new socket connections=20
coming in every second.

2) Is there a way the above for loop could use a random 'start' place, sear=
ch=20
through to the end, and then start at the beginning, until it ends up back =
at=20
the same place it started from, which would avoid it constantly treading th=
e=20
same ground (if the last entry used 1, its pretty assured 1 is still going =
to=20
be in use when you get the next entry, so you could either skip directly to=
=20
2, or randomly choose a new position to start at). (ie. something like:
	int port, start_port =3D (rand() % range) + min_port);
	for (port=3Dstart_port; port<min_port + range; port++)
		{ if (!used) { return 1; } }
	if (port =3D=3D min_port + range)
		for (port =3D min_port; port < start_port; port++)
			{ if (!used) { return 1; } }
	return 0;
).  Obviously, the kernel's rand would need to be used, etc.

3) Why does it need to do the unique check in the first place (for DNAT and=
=20
REDIRECT), since this code should only be triggered on a new connection, an=
d=20
if I have 2 new connections from the same source, to the same destination a=
nd=20
the same destination (nat'd) port, who cares?  The destination port has to =
be=20
listening for it anyway, and theres nothing stopping it accepting 2=20
connections from the same source to the same local port (the source port wi=
ll=20
always be different).  I'm assuming the 'resend' checks are done before thi=
s=20
point anyway (using the ORIGINAL destination ip/port, not the nat'd one) in=
=20
the system's TCP stack.

Anyway, if I'm way off base here, let me know, but I'm just trying to figur=
e=20
out why there is a difference between connecting to a port inside, and a po=
rt=20
outside the range I'm listening to on the router.  Its not a small differen=
ce=20
(time wise) either.

And re: your other email:
1) I know SNATs is not a TCP state, the data was copied from a file I gener=
ate=20
every 5 minutes gathering this data, and that was the line above what I men=
t=20
to copy.
2) When I said 'without state', I mean UDP connections, since they don't ha=
ve=20
TCP state information.

- --=20
PreZ
Systems Administrator
Shadow Realm

PGP FingerPrint: B3 0C F3 32 DE 5A 7D 90  26 F6 FA 38 CC 0A 2D D8
Finger prez@srealm.net.au for full PGP public key.

Shadow Realm, a hobbyist ISP supplying real internet services.
http://www.srealm.net.au
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1/2LKFp14D8AGEQRAhvtAKCGLi7R2DhiAGbluUhSxRBcuViR9wCfdU4J
+ycatke7LILAa+xRYDPOb7c=3D
=3DNgon
-----END PGP SIGNATURE-----

--=-bX/gbDZU9hi+uCVI7wMS--
