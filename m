From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [announce] arptables userspace tool
Date: Mon, 9 Jun 2003 23:18:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306092318.08599.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I've hacked up the userspace iptables program and made arptables out of i=
t. It=20
wasn't very hard.
No support for matches (yet), since the kernel code doesn't support them=20
(yet).
Bugreports are welcomed, it wasn't thoroughly tested.
A simple "make; make install; arptables -h" should do the trick.

I've put the tar.gz at the ebtables page, since I was too lazy to apply f=
or a=20
new project place for it:
http://sourceforge.net/projects/ebtables/
The CVS is there too:
http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/ebtables/ebtables2/userspa=
ce/arptables/

--=20
cheers,
Bart
