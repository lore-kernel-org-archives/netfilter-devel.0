From: Daniel Ahlberg <aliz@gentoo.org>
Subject: Compiling iptables without optimization flags
Date: Thu, 21 Nov 2002 11:02:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211211102.25692.aliz@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello

This bug (http://bugs.gentoo.org/show_bug.cgi?id=3D10424) explains the is=
sue=20
pretty well. I'm wondering if removing the #ifdef __OPTIMIZE__ ... #endif=
=20
from iptables.c, libiptc/libiptc.c and ip6tables.c is safe? If I remove t=
hose=20
the whole thing compiles and fram where I'm standing I can't see any issu=
es=20
with the compiled binary.

Please CC me as I'm not subscribed to this list.
