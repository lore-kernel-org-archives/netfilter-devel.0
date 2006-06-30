From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: 2.6.17.1 compile error with a netfilter module
Date: Fri, 30 Jun 2006 10:15:42 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F783@mail733.InfraSupportEtc.com>
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Does anyone know what this means and how to fix it?  I know it looks
like a file named lockhelp.h is missing.  I guess my question is, what
can I do to fix it?

With this build, I tried to put in some POM patches from
patch-o-matic-ng-20060624.  Could this have been my problem?=20

.

.

.

  CC [M]  net/ipv4/ipvs/ip_vs_nq.o
  CC [M]  net/ipv4/ipvs/ip_vs_ftp.o
scripts/Makefile.build:52: kbuild: net/ipv4/netfilter/Makefile - Usage
of=20
export-objs is obsolete in 2.6. Please fix!
  LD      net/ipv4/netfilter/built-in.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_standalone.o
In file included from include/linux/netfilter_ipv4/ip_conntrack.h:32,
                 from net/ipv4/netfilter/ip_conntrack_standalone.c:35:
include/linux/netfilter_ipv4/ip_conntrack_talk.h:7:43: error:=20
linux/netfilter_ipv4/lockhelp.h: No such file or directory
In file included from include/linux/netfilter_ipv4/ip_conntrack.h:32,
                 from net/ipv4/netfilter/ip_conntrack_standalone.c:35:
include/linux/netfilter_ipv4/ip_conntrack_talk.h:10: warning: data
definition has no=20
type or storage class
include/linux/netfilter_ipv4/ip_conntrack_talk.h:10: warning: type
defaults to 'int'=20
in declaration of 'DECLARE_LOCK_EXTERN'
include/linux/netfilter_ipv4/ip_conntrack_talk.h:10: warning: parameter
names=20
(without types) in function declaration
make[3]: *** [net/ipv4/netfilter/ip_conntrack_standalone.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
You have new mail in /var/spool/mail/root
[root@HHHC-fw linux]#
[root@HHHC-fw linux]#
[


thanks

- Greg Scott
