From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 2.2.1 released
Date: Tue, 19 Apr 2005 09:49:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504190947060.22052@blackhole.kfki.hu>
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

As the subject says, the new release of ipset can be downloaded from

http://ipset.netfilter.org/

[Thanks to Harald for the virtual server.]

The changelog:

2.2.1
 - Magic number in ip_set_nethash.h was mistyped (bug reported by Rob
   Carlson)
 - ipset can now test IP addresses in nethash type of sets (i.e. addresses
   in netblocks added to the set)

If you use nethash type of IP sets, please upgrade.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
