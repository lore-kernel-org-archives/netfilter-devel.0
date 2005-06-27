From: "Sebastian Aberle" <aberle@infotech.de>
Subject: RE: RSH helper concurrent sessions fix
Date: Mon, 27 Jun 2005 15:48:26 +0200
Message-ID: <JBEOIOMFMBOPMPLFDIALIEAACKAA.aberle@infotech.de>
References: <Pine.LNX.4.58.0506271350050.11307@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506271350050.11307@blackhole.kfki.hu>
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

On Mon, 27 Jun 2005, Jozsef Kadlecsik wrote:
> I'm not the author of the rsh helper ;-), but anyway, here goes my
> opinion:
>=20
> The protocol descriptions of rsh available for me are a little bit =
fuzzy:
>=20
> - According to Chapman & Zwicky, both the source and destination ports =
of
>   the error channel are below 1024.
> - The source code of rshd from netkit-rsh indeed makes sure that both
>   ports of the error channel be reserved.
> - The manpage of rshd does not state that the destination port must be
>   below 1024.
> - The protocol description in ip_conntrack_rsh.c itself does not state
>   either, but the code checks and rejects requested destination ports
>   above 1023.
>
> So first, what kind of system and rsh version do you use on the client =
and
> the server side?=20

I use quite a lot versions of RSH servers for different OSes (Windows =
NT4,=20
2000, Linux, SunOS). The client and also the server I tested with during =

experimenting are Linux NetKit 0.16 versions comming with SuSE 7.0.

> Could you post a tcpdump recording of an rsh session
> where the ports of the error channel are above 1023?=20

I never said that ports above 1023 are being used - indeed, they're not.
My patch does not enable the error channel connections to use =
unprivileged
ports, it only limits the expection being created from the data seen in
the first channel to exactly the one port the client communicates there.
I could post a tcpdump of such a (normal) connection though, of course.

I'll try to clarify my view of things:

The unpatched helper created an expectation with a dport mask of 0xfc00,
meaning any unprivileged port matches. In my case, I run an automated =
machine
status report generator that uses RSH to gather data from some machines,
like disk, memory and CPU usage etc. This script creates several =
parallel
RSH sessions at a quite fast interval, and that obviously confused the
connection tracker in a way that it "uses" the wrong expectation for =
some
incoming error channel connections, resulting in dropping these packets.
Creating one connection after another always worked flawlessly.

Now after my patch, the expectations are created for exactly the one =
port
that was chosen in the first connection (mask 0xffff). That seems to =
help
the connection tracker to find the right expectation for each RSH =
session.

> Second, I don't
> understand how could your patch relax the check on the destination =
port
> without other modifications.

It does not relax the checks, it even enforces them. That seems to be =
the
trick at all...

After all, please correct me if I'm wrong somewhere, I'm totally new to
all this. :-)


Greetings,

Sebastian Aberle
--
InfoTech GmbH
Holthoffstrasse 126
45659 Recklinghausen, GERMANY
www.infotech.de
