From: "Martin Bene" <martin.bene@icomedias.com>
Subject: ipt_connlimit.c module
Date: Fri, 11 Jul 2003 14:33:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4D618F6493CE064A844A5D496733D667031A4E@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've just tried to compile ipt_connlimit.c from current patch-o-matic
snapshot (20030710) on 2.4.21 kernel;=20

compilation fails with an error (NF_ACCEPT undeclared):

/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ip_conntrack_core.h: =
In
function `ip_conntrack_confirm':
In file included from ipt_connlimit.c:18:
/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ip_conntrack_core.h:44=
:
`NF_ACCEPT' undeclared (first use in this function)
/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ip_conntrack_core.h:44=
:
(Each undeclared identifier is reported only once
/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ip_conntrack_core.h:44=
:
for each function it appears in.)
/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ip_conntrack_core.h:45=
:
warning: control reaches end of non-void function

Fix: additional include seems to be needed:

#include <linux/netfilter.h>

Bye, Martin
