From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] manpages for 6 modules: ACCOUNT ipv4options policy quota
 recent tproxy
Date: Sat, 26 Mar 2005 20:47:11 +0200
Message-ID: <4245AE2F.1090305@outerspace.dyndns.org>
References: <42456AFE.7010000@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080206000803030804000600"
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42456AFE.7010000@outerspace.dyndns.org>
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
--------------080206000803030804000600
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jonas Berlin wrote:

| I sat down and put together man pages for most modules that were lacking
| one.

After getting a kebab, I sat down again.. :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCRa4txyF48ZTvn+4RAqyYAJ4gB1ruT66xYMVZYpUVPzmL8txg5ACfS2AN
f56WUCj28G01ETTJh9X3ua0=
=Q0Dx
-----END PGP SIGNATURE-----

--------------080206000803030804000600
Content-Type: text/x-patch;
 name="xkr47-iptables-manpages-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xkr47-iptables-manpages-2.patch"

Index: iptables/extensions/libipt_ipv4options.man
===================================================================
--- iptables/extensions/libipt_ipv4options.man	(revision 0)
+++ iptables/extensions/libipt_ipv4options.man	(revision 0)
@@ -0,0 +1,32 @@
+Match on IPv4 header options like source routing, record route,
+timestamp and router-alert.
+.TP
+.B "--ssrr"
+To match packets with the flag strict source routing.
+.TP
+.B "--lsrr"
+To match packets with the flag loose source routing.
+.TP
+.B "--no-srr"
+To match packets with no flag for source routing.
+.TP
+.B "\fR[\fB!\fR]\fB --rr"
+To match packets with the RR flag.
+.TP
+.B "\fR[\fB!\fR]\fB --ts"
+To match packets with the TS flag.
+.TP
+.B "\fR[\fB!\fR]\fB --ra"
+To match packets with the router-alert option.
+.TP
+.B "\fR[\fB!\fR]\fB --any-opt"
+To match a packet with at least one IP option, or no IP option
+at all if ! is chosen.
+.TP
+Examples:
+.TP
+$ iptables -A input -m ipv4options --rr -j DROP
+will drop packets with the record-route flag.
+.TP
+$ iptables -A input -m ipv4options --ts -j DROP
+will drop packets with the timestamp flag.
Index: iptables/extensions/libipt_recent.man
===================================================================
--- iptables/extensions/libipt_recent.man	(revision 0)
+++ iptables/extensions/libipt_recent.man	(revision 0)
@@ -0,0 +1,93 @@
+Allows you to dynamically create a list of IP addresses and then match
+against that list in a few different ways.
+
+For example, you can create a `badguy' list out of people attempting
+to connect to port 139 on your firewall and then DROP all future
+packets from them without considering them.
+.TP
+.BI "--name " "name"
+Specify the list to use for the commands. If no name is given then 'DEFAULT'
+will be used.
+.TP
+[\fB!\fR] \fB--set\fR
+This will add the source address of the packet to the list. If the
+source address is already in the list, this will update the existing
+entry. This will always return success (or failure if `!' is passed
+in).
+.TP
+[\fB!\fR] \fB--rcheck\fR
+Check if the source address of the packet is currently in
+the list.
+.TP
+[\fB!\fR] \fB--update\fR
+Like \fB--rcheck\fR, except it will update the "last seen" timestamp if it
+matches.
+.TP
+[\fB!\fR] \fB--remove\fR
+Check if the source address of the packet is currently in the list and
+if so that address will be removed from the list and the rule will
+return true. If the address is not found, false is returned.
+.TP
+[\fB!\fR] \fB--seconds \fIseconds\fR
+This option must be used in conjunction with one of \fB--rcheck\fR or
+\fB--update\fR. When used, this will narrow the match to only happen
+when the address is in the list and was seen within the last given
+number of seconds.
+.TP
+[\fB!\fR] \fB--hitcount \fIhits\fR
+This option must be used in conjunction with one of \fB--rcheck\fR or
+\fB--update\fR. When used, this will narrow the match to only happen
+when the address is in the list and packets had been received greater
+than or equal to the given value. This option may be used along with
+\fB--seconds\fR to create an even narrower match requiring a certain
+number of hits within a specific time frame.
+.TP
+\fB--rttl\fR
+This option must be used in conjunction with one of \fB--rcheck\fR or
+\fB--update\fR. When used, this will narrow the match to only happen
+when the address is in the list and the TTL of the current packet
+matches that of the packet which hit the \fB--set\fR rule. This may be
+useful if you have problems with people faking their source address in
+order to DoS you via this module by disallowing others access to your
+site by sending bogus packets to you.
+.P
+Examples:
+.IP
+# iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
+
+# iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
+.P
+Official website (http://snowman.net/projects/ipt_recent/) also has
+some examples of usage.
+
+/proc/net/ipt_recent/* are the current lists of addresses and information 
+about each entry of each list.
+
+Each file in /proc/net/ipt_recent/ can be read from to see the current list
+or written two using the following commands to modify the list:
+.TP
+echo xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
+to Add to the DEFAULT list
+.TP
+echo -xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
+to Remove from the DEFAULT list
+.TP
+echo clear > /proc/net/ipt_recent/DEFAULT
+to empty the DEFAULT list.
+.P
+The module itself accepts parameters, defaults shown:
+.TP
+.BI "ip_list_tot=" "100"
+Number of addresses remembered per table
+.TP
+.BI "ip_pkt_list_tot=" "20"
+Number of packets per address remembered
+.TP
+.BI "ip_list_hash_size=" "0"
+Hash table size. 0 means to calculate it based on ip_list_tot, default: 512
+.TP
+.BI "ip_list_perms=" "0644"
+Permissions for /proc/net/ipt_recent/* files
+.TP
+.BI "debug=" "0"
+Set to 1 to get lots of debugging info
Index: iptables/extensions/libipt_quota.man
===================================================================
--- iptables/extensions/libipt_quota.man	(revision 0)
+++ iptables/extensions/libipt_quota.man	(revision 0)
@@ -0,0 +1,7 @@
+Implements network quotas by decrementing a byte counter with each
+packet.
+.TP
+.BI "--quota " "bytes"
+The quota in bytes.
+.P
+KNOWN BUGS: this does not work on SMP systems.

--------------080206000803030804000600
Content-Type: text/x-patch;
 name="xkr47-pom-manpages-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xkr47-pom-manpages-2.patch"

Index: patch-o-matic-ng/policy/iptables/extensions/libip6t_policy.man
===================================================================
--- patch-o-matic-ng/policy/iptables/extensions/libip6t_policy.man	(revision 0)
+++ patch-o-matic-ng/policy/iptables/extensions/libip6t_policy.man	(revision 0)
@@ -0,0 +1,46 @@
+This modules matches the policy used by IPsec for handling a packet.
+.TP
+.BI "--dir " "in|out"
+Used to select whether to match the policy used for decapsulation or the
+policy that will be used for encapsulation.
+.B in
+is valid in the
+.B PREROUTING, INPUT and FORWARD
+chains,
+.B out
+is valid in the
+.B POSTROUTING, OUTPUT and FORWARD
+chains.
+.TP
+.BI "--pol " "none|ipsec"
+Matches if the packet is subject to IPsec processing.
+.TP
+.BI "--strict"
+Selects whether to match the exact policy or match if any rule of
+the policy matches the given policy.
+.TP
+.BI "--reqid " "id"
+Matches the reqid of the policy rule. The reqid can be specified with
+.B setkey(8)
+using
+.B unique:id
+as level.
+.TP
+.BI "--spi " "spi"
+Matches the SPI of the SA.
+.TP
+.BI "--proto " "ah|esp|ipcomp"
+Matches the encapsulation protocol.
+.TP
+.BI "--mode " "tunnel|transport"
+Matches the encapsulation mode.
+.TP
+.BI "--tunnel-src " "addr[/masklen]"
+Matches the source address of a tunnel. Only valid with --mode tunnel.
+.TP
+.BI "--tunnel-dst " "addr[/masklen]"
+Matches the destination address of a tunnel. Only valid with --mode tunnel.
+.TP
+.BI "--next"
+Start the next element in the policy specification. Can only be used with
+--strict
Index: patch-o-matic-ng/tproxy/iptables/extensions/libipt_TPROXY.man
===================================================================
--- patch-o-matic-ng/tproxy/iptables/extensions/libipt_TPROXY.man	(revision 0)
+++ patch-o-matic-ng/tproxy/iptables/extensions/libipt_TPROXY.man	(revision 0)
@@ -0,0 +1,7 @@
+Used to redirect new connections to the transparent proxy.
+.TP
+.BI "--on-port " "port"
+Redirect connection to port, or the original port if 0
+.TP
+.BI "--on-ip " "ip"
+Optionally redirect to the given IP
Index: patch-o-matic-ng/tproxy/iptables/extensions/libipt_tproxy.man
===================================================================
--- patch-o-matic-ng/tproxy/iptables/extensions/libipt_tproxy.man	(revision 0)
+++ patch-o-matic-ng/tproxy/iptables/extensions/libipt_tproxy.man	(revision 0)
@@ -0,0 +1 @@
+Matches all packets related to transparent-proxied connections.
Index: pom-all/ACCOUNT/iptables/extensions/libipt_ACCOUNT.man
===================================================================
--- pom-all/ACCOUNT/iptables/extensions/libipt_ACCOUNT.man	(revision 0)
+++ pom-all/ACCOUNT/iptables/extensions/libipt_ACCOUNT.man	(revision 0)
@@ -0,0 +1,16 @@
+A high performance accounting system for local networks.
+.TP
+.BI "--addr " "network/mask"
+the subnet which is accounted for
+.TP
+.BI "--tname " "name"
+is the table name where the information is stored
+.P
+The data can be queried later using the libipt_ACCOUNT userspace library
+or by the "iptaccount" tool which is part of the libipt_ACCOUNT package.
+
+A special subnet is "0.0.0.0/0": All data is stored in the src_bytes
+and src_packets structure of slot "0". This is useful if you want
+to account the overall traffic to/from your internet provider.
+
+For more information go to http://www.intra2net.com/opensource/ipt_account

--------------080206000803030804000600--
