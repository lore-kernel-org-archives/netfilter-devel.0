From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] tcp-window-tracking patch
Date: Tue, 9 Dec 2003 11:32:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0312091121400.5228-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

The new TCP window tracking patch in p-o-m has been committed with a lot
of improvements compared to the previous release:

- Silly window scaling bug fixed
- State table has been highly revised and a new internal state introduced
- More robust handling of new connections:
	- Reinitalized new connection requests are handled
	- New requests when the state table carries an apparently dead
	  connection are handled properly
- close_wait timeout value is lowered to the more proper 10 minutes
- Correspondig bugzilla patches fixed
- Other forgotten tunings & fixes :-)

Many thanks to Willy Tarreau for the excellent bugreports, suggestions,
code segments and testings!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
