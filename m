From: "Ye, Xiaolu" <xiaolu.ye@intel.com>
Subject: cross compile netfilter to arm-linux
Date: Fri, 27 Aug 2004 10:32:04 +0800
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <01385A324262E54DA1F2087B0A87EDBFA369EF@pdsmsx401.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi:

    I want to cross compile netfilter(1.2.7a) to my arm-linux
platform(Kernel 2.4.17-rmk3).

    I add these lines to the Makefile:

        CC :=3D /arm/bin/arm-linux-gcc #my arm gnu gcc

LD :=3D /arm/bin/arm-linux-ld  #my arm gnu linker

AR :=3D /arm/bin/arm-linux-ar

    Then compile the netfilter, some errors occur:

        include/linux/netfilter_ipv4/ipt_conntrack.h:28: `IP_CT_DIR_MAX'
undeclared here (not in a function)

include/linux/netfilter_ipv4/ipt_conntrack.h:29: `IP_CT_DIR_MAX'
undeclared here (not in a function)

include/linux/netfilter_ipv4/ipt_conntrack.h:29: `IP_CT_DIR_MAX'
undeclared here (not in a function)

extensions/libipt_conntrack.c: In function `parse_status':

extensions/libipt_conntrack.c:103: `IPS_EXPECTED' undeclared (first use
in this function)   =20

extensions/libipt_conntrack.c:103: (Each undeclared identifier is
reported only once

extensions/libipt_conntrack.c:103: for each function it appears in.)

extensions/libipt_conntrack.c:105: `IPS_SEEN_REPLY' undeclared (first
use in this function)

extensions/libipt_conntrack.c:107: `IPS_ASSURED' undeclared (first use
in this function)

extensions/libipt_conntrack.c: In function `parse':

extensions/libipt_conntrack.c:202: `IP_CT_DIR_ORIGINAL' undeclared
(first use in this function)

extensions/libipt_conntrack.c:259: `IP_CT_DIR_REPLY' undeclared (first
use in this function)

extensions/libipt_conntrack.c: In function `print_status':

extensions/libipt_conntrack.c:364: `IPS_EXPECTED' undeclared (first use
in this function)

extensions/libipt_conntrack.c:368: `IPS_SEEN_REPLY' undeclared (first
use in this function)

extensions/libipt_conntrack.c:372: `IPS_ASSURED' undeclared (first use
in this function)

extensions/libipt_conntrack.c: In function `matchinfo_print':

extensions/libipt_conntrack.c:420: `IP_CT_DIR_ORIGINAL' undeclared
(first use in this function)

extensions/libipt_conntrack.c:440: `IP_CT_DIR_REPLY' undeclared (first
use in this function)

make: *** [extensions/libipt_conntrack.o] Error 1

   For this error, I check the netfilter code, and add two enum to
ipt_conntrack.h/libipt_conntrack.c, and then pass these errors.

=20

    But, in compile progress, still have some errors:

        extensions/libipt_tos.c:58: warning: `struct ipt_tos_info'
declared inside parameter list

extensions/libipt_tos.c:58: warning: its scope is only this definition
or declaration, which is probably not what you want.

extensions/libipt_tos.c: In function `parse_tos':

extensions/libipt_tos.c:69: dereferencing pointer to incomplete type

extensions/libipt_tos.c:75: dereferencing pointer to incomplete type

extensions/libipt_tos.c: In function `parse':

extensions/libipt_tos.c:95: warning: passing arg 2 of `parse_tos' from
incompatible pointer type

extensions/libipt_tos.c:97: dereferencing pointer to incomplete type

extensions/libipt_tos.c: In function `print':

extensions/libipt_tos.c:141: dereferencing pointer to incomplete type

extensions/libipt_tos.c:142: dereferencing pointer to incomplete type

extensions/libipt_tos.c: In function `save':

extensions/libipt_tos.c:150: dereferencing pointer to incomplete type

extensions/libipt_tos.c:151: dereferencing pointer to incomplete type

extensions/libipt_tos.c: At top level:

extensions/libipt_tos.c:159: sizeof applied to an incomplete type

extensions/libipt_tos.c:160: sizeof applied to an incomplete type

make: *** [extensions/libipt_tos.o] Error 1

=20

How can I pass this error? Many Thanks!

=20

=20

Best Regards!

Ye.XiaoLu

=20

=20

=20
