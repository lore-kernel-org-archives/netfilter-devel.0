From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: initial ct_sync port for Linux 2.6
Date: Fri, 17 Dec 2004 00:10:00 +0100
Message-ID: <41C215C8.1070905@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
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


   Hi,

   In the last few days I've started porting ct_sync to Linux 2.6 and=20
Pablo Neira's new notifier API. This evening I managed to get it compile=20
and work on my UML-based "test system", so I thought it's time to=20
publish the code. However, since the 2.6 port is still in heavy=20
development, and because of my difficulties with the Netfilter SVN the=20
code is aveilable in a public GNU Arch archive repository here:

   http://people.netfilter.org/hidden/archives/2004-public

   For those of you unexperienced with tla, you can get the code using=20
the following magic incantations:

$ tla register-archive hidden@sch.bme.hu--2004-public \=20
http://people.netfilter.org/hidden/archives/2004-public
$ tla get -A hidden@sch.bme.hu--2004-public netfilter-ha--mainline--1.0

   The repository contains the complete patchset for Linux 2.6.9, plus=20
the ported ct_sync code. I've done some changes in the code itself as wel=
l:

- simplified conntrack entry manipulation code while trying to minimize=20
necessary core conntrack patches
- ct_sync does not depend on ctnetlink anymore, only Pablo Neira's new=20
per-packet conntrack notifier patch is necessary
- the patchtree for 2.6.9 still contains the connmark patch, which has=20
been included in the mainline kernel recently, so it won't be necessary=20
for 2.6.10
- polling support in the receive thread has also been included, this=20
feature is especially experimental (comments welcome)

   Unfortunately I did not have time to update the README yet, it's=20
slightly outdated when describing the patching process required to=20
compile ct_sync. However, with a little imagination everyone should be=20
able to guess which changes to apply to the commands in the README. :)

   Of course, there are a couple of known bugs in the code as well, and=20
the whole 2.6 tree is even more experimental than the 2.4 variant of the=20
code.

--=20
   KOV=C1CS, Kriszti=E1n
