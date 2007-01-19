From: "Michael Steinmann" <msl@calivia.com>
Subject: Re: [nf-failover] [ANNOUNCE] conntrackd-0.9.2 released
Date: Fri, 19 Jan 2007 13:40:29 +0100 (CET)
Message-ID: <35679.193.5.216.100.1169210429.squirrel@www2.calivia.com>
References: <45AD8EA7.6030705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: lwn@lwn.net,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <45AD8EA7.6030705@netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
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

On Wed, January 17, 2007 3:49 am, Pablo Neira Ayuso wrote:
> This project is under development, people feeling brave are encouraged
> to test a send nice reports ;)

thanks for the new release.
I noticed a small glitch with keyword case in the persistent mode example
config files:

examples/sync/persistent/node1/conntrackd.conf
       mode PERSISTENT {

examples/sync/persistent/node2/conntrackd.conf
       Mode PERSISTENT {

The Mode keyword is case sensitive which will lead to the following error
when starting node1:

Error parsing config file: line (5), symbol 'mode': syntax error



Also, to build conntrackd I had to patch two include files:

--- /usr/local/include/libnfnetlink/libnfnetlink.h.orig 2007-01-19
08:46:42.000000000 +0100
+++ /usr/local/include/libnfnetlink/libnfnetlink.h      2007-01-19
13:35:19.000000000 +0100
@@ -16,7 +16,6 @@
 #endif

 #include <linux/types.h>
-#include <sys/socket.h>        /* for sa_family_t */
 #include <linux/netlink.h>
 #include <libnfnetlink/linux_nfnetlink.h>


---
/usr/local/include/libnetfilter_conntrack/libnetfilter_conntrack.h.orig  =
=20
 2007-01-19 08:48:13.000000000 +0100
+++ /usr/local/include/libnetfilter_conntrack/libnetfilter_conntrack.h=20
2007-01-19 13:34:47.000000000 +0100
@@ -8,7 +8,6 @@
 #ifndef _LIBNETFILTER_CONNTRACK_H_
 #define _LIBNETFILTER_CONNTRACK_H_

-#include <netinet/in.h>
 #include <libnfnetlink/linux_nfnetlink.h>
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_conntrack/linux_nfnetlink_conntrack.h>
@@ -338,7 +337,6 @@

 /* high level API */

-#include <sys/types.h>

 /* conntrack object */
 struct nf_conntrack;


This is with libnfnetlink-0.0.25 and libnetfilter_conntrack-0.0.50 as per
the docs. Kernel is 2.6.20.

--
mike
