From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: ipset updated in svn
Date: Mon, 26 Jun 2006 15:10:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0606261452020.20933@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
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

I just wanted to let you know that the kernel part of ipset has been
updated in svn: thanks to everyone who sent patches to catch up the
internal 2.6.x API changes.

The committed code should work on every latest release from the 2.6.15.x,
2.6.16.x and 2.6.17.x series but it might still be be incompatible with
earlier releases as extraversion cannot be checked at preprocessing time.

If you have got problems to compile/run it using the latest extraversion,
please let me know.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
