From: Victor Stinner <victor.stinner@inl.fr>
Subject: Problems with autotools
Date: Tue, 23 Jan 2007 12:24:43 +0100
Message-ID: <200701231224.43655.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I noticed minor problems with autotools:

=2D conntrack: autoheader 2.60 fails because location of config.h is missin=
g=20
   ~~> add =AB AM_CONFIG_HEADER(config.h) =BB in configure.in

=2D libnfnetlink, libnetfilter_conntrack, libnetfilter_queue autogen.sh use=
 "=3D=3D"=20
to compare string whereas sh only accepts "=3D"=20
   ~~> use =AB [ "x$1" =3D "xdistrib" ] && include =BB

=2D libtoolize may use option --force and --automake

Victor Stinner
http://www.inl.fr/
