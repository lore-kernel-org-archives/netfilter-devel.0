From: "Oscar A. Valdez" <oscar.valdez@duraflex-politex.com>
Subject: IPSEC end-points on the same systems as Netfilter
Date: Tue, 25 Oct 2005 10:40:45 -0600
Message-ID: <1130258445.3847.31.camel@wzowski.plastipak.com.sv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

After upgrading from the 2.4 to the 2.6 kernel and discarding the cipe
(Crypto-IP Encapsulation) package because of its incompatibility with
2.6, I've been struggling hard to get IPSEC and Netfilter to coexist and
cooperate on two IPSEC tunnel endpoints.

My setup is very much like that described by Tom Eastep in
http://www.shorewall.net/IPSEC-2.6.html#id2459973,
except that I don't run the Shorewall package, just plain iptables
rules. 

Currently, I see the ESP packages arriving from the other endpoint, but
I don't see them after they are decrypted.

I've patched the 2.6.12 kernel with Christophe Saout's patches at
http://www.saout.de/misc/linux-2.6.12-ipsec-nat/ (ipsec-01-output-
hooks.diff, ipsec-02-input-hooks.diff, ipsec-03-policy-lookup.diff,
ipsec-04-policy-checks.diff), without luck.

I'm about to rebuild the kernel and iptables with the ipsec-05-
iptablescompile.diff from
http://shorewall.net/pub/shorewall/contrib/IPSEC/2.6.12/,
but I face the following difficulties applying the "policy patch"
extension from patch-o-matic-ng-20051024.tar.bz2:

1) Will I be safe applying the extensions in policy/linux-2.6.10/ to the
2.6.12 kernel?

2) I would prefer to apply the extensions in policy/linux-2.6.10/ and in
policy/iptables/extensions/ to the kernel and to iptables directly by
means of .spec files, in order to produce kernel and iptables rpms. How
can I apply the extensions by means of .spec files? I would really
prefer to produce rpms's.
-- 
Oscar A. Valdez
