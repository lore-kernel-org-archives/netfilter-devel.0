From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [testsuite] ipt_mac testcase
Date: Fri, 17 Dec 2004 18:15:22 -0500
Message-ID: <41C3688A.4030302@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030007010700010001000405"
Cc: netfilter-devel@lists.netfilter.org,
	Nicolas Bouliane <nib@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
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

This is a multi-part message in MIME format.
--------------030007010700010001000405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rusty,

Like the subject suggests, here's the ipt_mac testcase.
This is your third christmas gift. Please, don't try to find out how much
I paid for... 8)~

As of revision 3436:
    * attached a tiny patch removing bad entry into expected-failures.
    * the other one is about 01iptables/27ipt_iprange-bad-addr.sim

iptables -A INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --src-range 
1.1.1.1-2.2.2.2
iptables -A INPUT -m iprange --dst-range 0.0.0.0-1.1.1.1 --dst-range 
1.1.1.1-2.2.2.2

Above rules should fail. Added expects...

Let me know if I missed something.

Cheers,

--peejix

--------------030007010700010001000405
Content-Type: text/plain;
 name="34ipt_mac-bad-addr.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="34ipt_mac-bad-addr.sim"

# Straight rule (expecting: success)
iptables -I INPUT -m mac --mac-source 00:50:BA:56:CB:3A
iptables -D INPUT -m mac --mac-source 00:50:BA:56:CB:3A

# Inverted rule (expecting: success)
iptables -I INPUT -m mac ! --mac-source 00:50:BA:56:CB:3A
iptables -D INPUT -m mac ! --mac-source 00:50:BA:56:CB:3A
iptables -I INPUT -m mac --mac-source ! 00:50:BA:56:CB:3A
iptables -D INPUT -m mac --mac-source ! 00:50:BA:56:CB:3A

# Inverted twice (expecting: failure)
expect iptables iptables: command failed
iptables -I INPUT -m mac ! --mac-source ! 00:50:BA:56:CB:3A

# Bad MAC address (expecting: failure)
expect iptables iptables: command failed
iptables -I INPUT -m mac --mac-source 00:50:BA:56:CB:
expect iptables iptables: command failed
iptables -I INPUT -m mac --mac-source 00:50:BA:56:CB
expect iptables iptables: command failed
iptables -I INPUT -m mac --mac-source 00:50:BA:56:CB:3A:
expect iptables iptables: command failed
iptables -I INPUT -m mac --mac-source 00:50:BA:56:CB:3A:00

--------------030007010700010001000405
Content-Type: text/plain;
 name="35ipt_mac.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="35ipt_mac.sim"

# Straight rule
iptables -I INPUT -m mac --mac-source 00:50:BA:56:CB:3A -j DROP

	# source MAC matches
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 MAC=00:50:BA:56:CB:3A 192.168.0.2 192.168.0.1 0 6 1 2 SYN

	# source MAC doesn't
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 MAC=00:A0:C9:5A:94:EF 192.168.0.2 192.168.0.1 0 6 1 2 SYN

iptables -D INPUT -m mac --mac-source 00:50:BA:56:CB:3A -j DROP

# Inverted rule
iptables -I INPUT -m mac ! --mac-source 00:50:BA:56:CB:3A -j DROP

	# source MAC matches
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 MAC=00:50:BA:56:CB:3A 192.168.0.2 192.168.0.1 0 6 1 2 SYN

	# source MAC doesn't
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 MAC=00:A0:C9:5A:94:EF 192.168.0.2 192.168.0.1 0 6 1 2 SYN

iptables -D INPUT -m mac ! --mac-source 00:50:BA:56:CB:3A -j DROP


--------------030007010700010001000405
Content-Type: text/x-patch;
 name="expected-failures-remove_entry.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expected-failures-remove_entry.patch"

--- expected-failures	2004-12-17 17:34:13.000000000 -0500
+++ expected-failures.fix	2004-12-17 17:55:57.000000000 -0500
@@ -26,4 +26,3 @@
 linux:2.6.10*:03NAT/21loopback.sim
 iptables:*:01iptables/26ipt_ttl-out-of-range.sim
 iptables:*:01iptables/27ipt_iprange-bad-addr.sim
-*:01iptables/27ipt_iprange-bad-addr.sim

--------------030007010700010001000405
Content-Type: text/x-patch;
 name="27ipt_iprange-bad-addr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="27ipt_iprange-bad-addr.patch"

--- 01iptables/27ipt_iprange-bad-addr.sim	2004-12-16 23:37:50.000000000 -0500
+++ 01iptables/27ipt_iprange-bad-addr.sim.fix	2004-12-17 17:52:22.000000000 -0500
@@ -8,17 +8,16 @@
 # Check if inputing the same option twice override previous one.
 # This should ring the bell.
 # Side note: Fixed in SVN since Mon Jul 12 07:16:54 2004 UTC, Revision 1407
-
+expect iptables iptables: command failed
 iptables -A INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --src-range 1.1.1.1-2.2.2.2
+expect iptables iptables: command failed
 iptables -A INPUT -m iprange --dst-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2
 
 # Giving a source and destination range should succeed.
 iptables -A INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2
+iptables -D INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2
 
-# Invert
+# Invert rule too...
 iptables -A INPUT -m iprange ! --src-range 0.0.0.0-1.1.1.1 ! --dst-range 1.1.1.1-2.2.2.2
-
-# Remove me!
-iptables -D INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2
 iptables -D INPUT -m iprange ! --src-range 0.0.0.0-1.1.1.1 ! --dst-range 1.1.1.1-2.2.2.2
 

--------------030007010700010001000405--
