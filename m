From: "Preston A. Elder" <prez@srealm.net.au>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 13:42:07 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305301342.16153.prez@srealm.net.au>
References: <200305290113.58552.prez@srealm.net.au> <200305290810.16531.prez@srealm.net.au> <20030530080806.GB29312@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030530080806.GB29312@sunbeam.de.gnumonks.org>
Content-Description: clearsigned data
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Friday 30 May 2003 04:08 am, Harald Welte wrote:
> > That was not my point.  My point was, for up to 5 days later, the
> > system still has entries in the conntrack table (listed as
> > 'ESTABLISHED'), which have been dead and gone for a long time,
> > conntrack does not realise that connection is utterly closed, and it
> > should drop its conntrack entry.  I'm not as worried about the
> > lower-value timeouts, but as I said, I saw ALOT of established
> > connections hanging around in the conntrack table (making the
> > conntrack table about 200,000 entries long, give or take), most of
> > which were entries for connections already closed.
>
> This is exactly the behaviour shown by kernels that have not the above bug
> fix applied.
>
> Can you please verify that this is indeed a conntrack bug?  Can you do
> some tcpdump capturing that actually shows that there was a connection
> teardown (FIN handshake or RST) and after it, conntrack state of the
> respective connection stays ESTABLISHED?
>
> I just want to make sure that this is really some problem about a
> possible conntrack bug - not some application that forgets to fully
> close TCP connections..

OK, just to be sure, I just installed kernel 2.4.21-rc6, with all the=20
'pending' patches applied to it as well, these are the ONLY patches applied=
=20
to this kernel.

Netstat is showing me the following connection breakdowns:
SNATs: 0
ESTABLISHED : 1060
LAST_ACK    : 4865
TIME_WAIT   : 29
=46IN_WAIT2   : 1
=46IN_WAIT1   : 39
SYN_RECV    : 3277
LISTEN      : 100
CLOSE_WAIT  : 9261

/proc/ip_conntrack, however, is showing me the following:
CLOSE: 176
CLOSE_WAIT: 111
ESTABLISHED: 9046
=46IN_WAIT: 8634
SYN_RECV: 134
SYN_SENT: 25111
TIME_WAIT: 2165
(no state): 128

Remember, the *ONLY* natting this machine is (or should be) doing is=20
re-directing any new TCP connection bound for (remote_range) port range=20
1025-65535, to a local port range of about 100 ports (using REDIR, I used t=
o=20
use DNAT, same difference though).  So the above counts seem very wrong to=
=20
me.  And although the established count is very high, the SYN_SENT count is=
=20
astronomical.

There are also, as you see above, 128 conntrack entries without a state, wh=
ich=20
by the look of it, are UDP connections.  I'm not even natting anything for=
=20
UDP.  WTF is going on here?

=2D --=20
PreZ
Systems Administrator
Shadow Realm

PGP FingerPrint: B3 0C F3 32 DE 5A 7D 90  26 F6 FA 38 CC 0A 2D D8
=46inger prez@srealm.net.au for full PGP public key.

Shadow Realm, a hobbyist ISP supplying real internet services.
http://www.srealm.net.au
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+15f3KFp14D8AGEQRAhpaAKCVH+L/nPFDd1Q8Z4PxmtYs4LBTygCeOVED
XIRAa3VHcNSd+Jc3D8nrXLs=3D
=3D9WvM
=2D----END PGP SIGNATURE-----
