From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: lockhelp.h missing
Date: Fri, 22 Jul 2005 01:34:39 -0400
Message-ID: <debc30fc050721223469bd79d6@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

I've got latest kernel 2.6.13-r1 with andrew morton patch mm1 and
applied latest patch-o-matic-ng (2005-07-21 today) with ./runme extra
which successfully applied.

When compiling the kernel I get some bad result (quoted some errors
below) because of the lockhelp.h file missing in kernel builds greater
or equal to 2.6.12.

This error repeats for each file including ip_conntrack_mms.h after
removing lockhelp.h from the #include
---------------------
In file included from include/linux/netfilter_ipv4/ip_conntrack.h:94,
                 from net/ipv4/netfilter/ip_conntrack_h323_core.c:17:
include/linux/netfilter_ipv4/ip_conntrack_mms.h:8: warning: type
defaults to `int' in declaration of `DECLARE_LOCK_EXTERN'
include/linux/netfilter_ipv4/ip_conntrack_mms.h:8: warning: parameter
names (without types) in function declaration
include/linux/netfilter_ipv4/ip_conntrack_mms.h:8: warning: data
definition has no type or storage class
------------

Same for this one after touch-ing the file so it doesn't generate
errors about the missing #include
-----------
net/ipv4/netfilter/ip_conntrack_h323_h225.c: In function `h225_help':
net/ipv4/netfilter/ip_conntrack_h323_h225.c:382: warning: implicit
declaration of function `LOCK_BH'
net/ipv4/netfilter/ip_conntrack_h323_h225.c:382: error: `ip_h225_lock'
undeclared (first use in this function)
net/ipv4/netfilter/ip_conntrack_h323_h225.c:382: error: (Each
undeclared identifier is reported only once
net/ipv4/netfilter/ip_conntrack_h323_h225.c:382: error: for each
function it appears in.)
net/ipv4/netfilter/ip_conntrack_h323_h225.c:390: warning: implicit
declaration of function `UNLOCK_BH'
net/ipv4/netfilter/ip_conntrack_h323_h225.c: At top level:
net/ipv4/netfilter/ip_conntrack_h323_h225.c:28: warning:
'DECLARE_LOCK' declared `static' but never defined
make[3]: *** [net/ipv4/netfilter/ip_conntrack_h323_h225.o] Error 1
--------------
