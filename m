From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: A humble proposal
Date: Thu, 25 Sep 2003 17:19:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF5122E53@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter@lists.netfilter.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <firewalldude@newkirk.us>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I had a thought about this, and I see a lot of work taking this
approach.

How about this:

Write a jump target that applies only inside the filter table, since the
first revision would just implement filtering control.

The module itself would be initialized by a userspace tool be adding
rules. An example would be:

iptables -I INPUT -m expire --expire-condition timer=3D6000 --expire-id
12123124325 --source 192.168.1.1/24 -j ACCEPT
iptables -I OUTPUT -m expire --expire-condition timer=3D6000 --expire-id
12123124326 --destination 192.168.1.1/24 -j ACCEPT

Since they are inserted in these tables, they should be called before
ESTABLISHED,RELATED is even hit.

The jump determines if the packets are valid any longer. The problems
that I can see here are:

- The rule itself needs to be cleared out of the chain once it is
expired. I could get the daemon to do some housekeeping, but it'd be
better if the jump module could clean up its own reference. Can this be
done?

- The CONNTRACK entries for the allowed sessions are not dropped. Once
again, it would be nice if the jump module could clean up the CONNTRACK
entry.


-----Original Message-----
From: Joel Newkirk [mailto:firewalldude@newkirk.us]=20
Sent: Tuesday, September 23, 2003 2:10 PM
To: Daniel Chemko
Cc: netfilter@lists.netfilter.org; netfilter-devel@lists.netfilter.org
Subject: Re: A humble proposal

On Tue, 2003-09-23 at 12:13, Daniel Chemko wrote:
> I have been researching some possible extensions to the Netfilter
> environment, and something has become very necessary for my current
> environment. The following proposal outlines what I wish to implement.
I
> am wondering if anyone would find value in this. Plus, I look forward
to
> feedback so that I may improve my ideas.


> Suggestion:
>=20
> I would like to take pam_iptables and expand it beyond its simple
> structure. Features will include:

My humble suggestion would be that this should be handled in the
stateful
connection tracking - If a session is authenticated and certain
connections
are to be allowed, then the new allowed connections would be of state=20
"related".  Really handy would be the ability to distinguish these
particular
'related' connections and feed them through specific chains.  I for one=20
would NOT want to simply open the box (or network) wide for every
authenticated=20
connection, but would like to be able to specify a different set of
(more=20
permissive) rules for them once authenticated.  Perhaps patch an
additional
state - "PAM" or "AUTH".  Or the ability to specify a fwmark that is
automatically implemented for RELATED traffic to the authenticated
session,
allowing different chains to be traversed based on the mark found.

j
