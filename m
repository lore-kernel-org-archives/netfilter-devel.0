From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 2.2.3 released
Date: Wed, 14 Sep 2005 12:46:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0509141241230.23538@blackhole.kfki.hu>
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

I'm happy to announce ipset 2.2.3. The changes compared to the previous
release are:

- memory allocation bug in iphash and nethash in connection with the SET
  target was fixed (bug reported by Nikolai Malykh)
- lockhelp.h was removed from the 2.6.13 kernel tree, ip_set.c is
  updated accordingly (Cardoso Didier, Samir Bellabes)
- manpage is updated to clearly state the command order in restore mode

If you use or plan to use an iphash or nethash type of set with the SET
target, I urge you to upgrade.

The source code can be downloaded from the ipset homepage at
http://ipset.netfilter.org/ or from the netfilter svn repository.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
