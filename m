From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCEMENT] ipset 2.1.0 released
Date: Wed, 19 Jan 2005 16:08:15 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501191545160.10783@blackhole.kfki.hu>
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

I'm happy to announce ipset 2.1.0. Besides a couple of bugfixes, it
includes a new maptype called nethash by which one can store/match
different size of CIDR netblocks in a set.

Please read the webpage on ipset: http://people.netfilter.org/kadlec/ipset

You can download the snapshots from there or directly from the netfilter
svn:

svn co https://svn.netfilter.org/netfilter/trunk/ipset
svn co https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng
svn co https://svn.netfilter.org/netfilter/trunk/iptables

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
