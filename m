From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] patch-o-matic-ng reorganization and updated patches
Date: Thu, 19 Feb 2004 13:22:14 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402191309230.14327-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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

Hello,

A lot of modification happened today in pom-ng:

- last two Netfilter_POM.pm patches are applied
- configure.help files are renamed as
  linux/Documentation/Configure.help.ladd and Netfilter_POM.pm
  is changed to take the change into account
- the 2.6 port of the nf-log, raw and TRACE patches are added
  to pom-ng

Upcoming modifications:

- relax the version checking, because it's too rigid: foo-1.2.patch
  should support anything equal and above 1.2 if there is no better
  match
- 2.6 ports of tcp-window-tracking and conntrack_foo patches

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
