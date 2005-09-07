From: Samir Bellabes <sbellabes@mandriva.com>
Subject: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Thu, 08 Sep 2005 01:11:06 +0200
Message-ID: <m2zmqoscc5.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Harald Welte <laforge@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--=-=-=

Hi,

when loading ip_conntrack_{ftp,tftp,irc} with 'ports=1234567890'
parameter option for example, a buffer overflow occur when :
sprintf(tmpname, "ftp-%d", ports[i]);
because of sizeof("ftp-1234567890") > 10
10 is the size of each array *_names[port][10]

Please apply this patch.

regards, 
Samir Bellabes


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=nf_bad_param_port.patch

tree f8f9de37b0294e8049a959dfa5acc2efc64ab231
parent 48bc41a49c4f3aa760dff84e7f71437f5ed520fe
author Samir Bellabes <sbellabes@mandriva.com> 1126118922 +0200
committer Samir Bellabes <sbellabes@mandriva.com> 1126118922 +0200

[NETFILTER] Check for bad parameter value of 'ports' in ip_ct_{ftp,tftp,irc}

A buffer overflow occur when parameter 'ports' value is > 65535 :
if the number of digits of ports exceeds, for the ftp example:
sizeof ftp_names[A_PORT][10] - strlen("ftp-") = 10-4 = 6 
then : sprintf(tmpname, "ftp-%d", ports[i]) produce the overflow.

This patch checks for 0 < port < 65356.

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>
------------------------------------------------------------------------------

 ip_conntrack_ftp.c  |    7 +++++++
 ip_conntrack_irc.c  |    7 +++++++
 ip_conntrack_tftp.c |    7 +++++++
 3 files changed, 21 insertions(+)

------------------------------------------------------------------------------

diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -478,6 +478,13 @@ static int __init init(void)
 		ports[ports_c++] = FTP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
+		/* don't allow bad port values */
+		if (ports[i] < 1 || ports[i] > 65535) {
+			printk(KERN_WARNING "ip_ct_ftp: ERROR port"
+			       "should be between 1 and 65535\n");
+			fini();
+			return -EINVAL;
+		}
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].mask.src.u.tcp.port = 0xFFFF;
diff --git a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
--- a/net/ipv4/netfilter/ip_conntrack_irc.c
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c
@@ -268,6 +268,13 @@ static int __init init(void)
 		ports[ports_c++] = IRC_PORT;
 
 	for (i = 0; i < ports_c; i++) {
+		/* don't allow bad port values */
+		if (ports[i] < 1 || ports[i] > 65535) {
+			printk(KERN_WARNING "ip_conntrack_irc: ERROR port"
+			       "should be between 1 and 65535\n");
+			fini();
+			return -EINVAL;
+		}
 		hlpr = &irc_helpers[i];
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
diff --git a/net/ipv4/netfilter/ip_conntrack_tftp.c b/net/ipv4/netfilter/ip_conntrack_tftp.c
--- a/net/ipv4/netfilter/ip_conntrack_tftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_tftp.c
@@ -122,6 +122,13 @@ static int __init init(void)
 		ports[ports_c++] = TFTP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
+		/* don't allow bad port values */
+		if (ports[i] < 1 || ports[i] > 65535) {
+			printk(KERN_WARNING
+			       "ERROR port should be between 1 and 65535\n");
+			fini();
+			return -EINVAL;
+		}
 		/* Create helper structure */
 		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
 

--=-=-=--
