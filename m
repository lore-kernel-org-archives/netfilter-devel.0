From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ipt_ULOG delays packets caught by filter
Date: Tue, 20 Jul 2004 02:45:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40FC6B44.50407@eurodev.net>
References: <20040720001021.GA4226@wonderland>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080801010601070001020403"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ruby joker <ruby.joker@op.pl>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>
In-Reply-To: <20040720001021.GA4226@wonderland>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080801010601070001020403
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

ruby joker wrote:

>Maybe bug is hard to notice but it decrease ulog reliability.
>[1] http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015860.html
>  
>

I think that this behaviour is related to the default qthreshold value. 
If I'm not wrong, we could fix this problem setting the default value to 
0 instead of 1. In that case we need to update the iptables man page. If 
I'm missing something, please let me know.

regards,
Pablo

--------------080801010601070001020403
Content-Type: text/x-patch;
 name="ulog.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ulog.patch"

diff -u -r1.1.1.1 ipt_ULOG.h
--- a/include/linux/netfilter_ipv4/ipt_ULOG.h	11 May 2004 13:35:40 -0000	1.1.1.1
+++ b/include/linux/netfilter_ipv4/ipt_ULOG.h	20 Jul 2004 00:34:30 -0000
@@ -12,7 +12,7 @@
 #endif
 
 #define ULOG_DEFAULT_NLGROUP	1
-#define ULOG_DEFAULT_QTHRESHOLD	1
+#define ULOG_DEFAULT_QTHRESHOLD	0
 
 #define ULOG_MAC_LEN	80
 #define ULOG_PREFIX_LEN	32

--------------080801010601070001020403
Content-Type: text/x-patch;
 name="man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="man.patch"

Index: libipt_ULOG.man
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_ULOG.man,v
retrieving revision 1.1
diff -u -r1.1 libipt_ULOG.man
--- libipt_ULOG.man	22 Jan 2004 15:04:24 -0000	1.1
+++ libipt_ULOG.man	20 Jul 2004 00:55:33 -0000
@@ -22,6 +22,6 @@
 .BI "--ulog-qthreshold " "size"
 Number of packet to queue inside kernel.  Setting this value to, e.g. 10
 accumulates ten packets inside the kernel and transmits them as one
-netlink multipart message to userspace.  Default is 1 (for backwards
+netlink multipart message to userspace.  Default is 0 (for backwards
 compatibility).
 .br

--------------080801010601070001020403--
