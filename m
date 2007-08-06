From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: conntrack clarification
Date: Mon, 06 Aug 2007 14:37:07 +0200
Message-ID: <46B715F3.5050406@plouf.fr.eu.org>
References: <3434740.221186389567173.JavaMail.root@localhost>
	<24966838.281186390464437.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <24966838.281186390464437.JavaMail.root@localhost>
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

Hello,

Andrew Hall a =E9crit :
>=20
> 1. First, set up SSH connection with the following ruleset:
>=20
> - add a rule matching "established and related" connections to be allow=
ed
> - add a rule matching "new" connections from host for SSH to be allowed
> - Policy is drop all

I suppose this is the INPUT ruleset. What about the OUTPUT rules ?

> 2. SSH is connected from host running 'top' to keep the session active
>=20
> 3. delete the "new" connection rule and 'conntrack -F' to flush the
> existing connections.
>=20
> At this point I would have thought the conntrack table doesn't know
> the existing connection is "established" because the table entry is gon=
e
> and without the "new" rule providing connection establishment, the
> session should be lost?

Just a guess. Could it be 'top' periodically refreshing the display=20
which causes the server to send traffic to the client over the SSH=20
session, and that traffic is accepted by the OUTPUT rules and re-adds=20
the conntrack entry ?
