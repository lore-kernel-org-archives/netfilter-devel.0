From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.2.9 released
Date: Mon, 8 May 2006 12:17:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0605081138230.4039@blackhole.kfki.hu>
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

This is a bugfix release. The list of the fixed bugs is

 - 'ipset -N' did not generate proper return code
 - 'limit' module parameter added to the kernel modules of the
   iphash, ipporthash, nethash and iptree type of sets so that
   the maximal number of elements can now be limited
 - zero valued entries (port 0 or IP address 0.0.0.0) were
   detected as members of the hash/tree kind of sets
   (reported by Andrew Kraslavsky)
 - list and save operations used the external identifier
   of the sets for the bindings instead of the internal one
   (reported by Amin Azez)

If you use hash/iptree type of sets to dynamically protect your network
via the SET target, I strongly suggest you to upgrade: in the previous
releases there was no limit on the number of the possible elements in a
hash/iptree type of set and thus an attacker could exhaust the available
physical memory in the machine by triggering adding bogus, faked entries.

Now there is a default of max 65535 elements in the hash/iptree type of
sets: you can adjust it per settype by setting the 'limit' parameter of
the appropriate kernel module, e.g:

	# modprobe ip_set_iphash limit=10000

You can download the new release from http://ipset.netfilter.org or from
the netfilter svn tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
