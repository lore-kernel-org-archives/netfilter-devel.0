From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCEMENT] ipset 2.2.0 released
Date: Mon, 11 Apr 2005 10:51:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504111021210.5292@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
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

I'm happy to announce ipset 2.2.0. The new release contains the following
fixes and new features:

- Locking bug in ip_set_nethash.c fixed (Clifford Wolf and Rob Carlson)
- ipset Makefile contained an unnecessary variable in IPSET_LIB_DIR
  (Clifford Wolf)
- Safety checkings of restore mode in ipset was incomplete (Robin H.
  Johnson)
- More careful resizing mode added by avoiding running under lock
- stdin stored internally in a temporary file, so from now on we can feed
  'ipset -R' from a pipe

A new set type called 'iptree' (inspired and triggered by Clifford
Wolf) added, which makes possible to store IP addresses which
automatically time out. Please note, this is an initial new feature with
some hardcoded parameter (like the frequency of garbage collection) and
thus may change in the future.

The svn repository at svn.netfilter.org contains the updated ipset and
patch-o-matic-ng directories. Snapshots are available from the usual place
at http://people.netfilter.org/kadlec/ipset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
