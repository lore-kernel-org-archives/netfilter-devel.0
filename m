From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Conntrack & NAT question
Date: Thu, 15 Jul 2004 17:12:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F69EC8.80903@eurodev.net>
References: <1089882225.2556.10.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040103050700030701020901"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1089882225.2556.10.camel@nienna.balabit>
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
--------------040103050700030701020901
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Krisztian,

KOVACS Krisztian wrote:

>  The 'new' parameter means we're updating an entry we've just created.
>So, unless the entry is new, we check whether the tuples in the update
>message are the same as ours. And, unfortunately, I have a few assertion
>failed messages in the logs... :(
>  
>

maybe this could be related to the initialization of the tuple and 
repl_tuple contained in ct_sync message. I didn't have much time to have 
a look at ct_sync implementation so far, if I'm missing anything, please 
let me know.

regards,
Pablo

--------------040103050700030701020901
Content-Type: text/x-patch;
 name="memset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="memset.patch"

? memset.patch
Index: Makefile
===================================================================
RCS file: /cvspublic/netfilter-ha/ct_sync/Makefile,v
retrieving revision 1.3
diff -u -r1.3 Makefile
--- Makefile	30 Jan 2004 20:24:26 -0000	1.3
+++ Makefile	15 Jul 2004 14:14:55 -0000
@@ -1,5 +1,5 @@
 # set to your kernel tree
-KERNEL  = /usr/src/linux-ctsync
+KERNEL  = /usr/src/new/linux-2.4.24
 
 # get the Linux architecture. Needed to find proper include file for CFLAGS
 ARCH=$(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/)
Index: ct_sync_main.c
===================================================================
RCS file: /cvspublic/netfilter-ha/ct_sync/ct_sync_main.c,v
retrieving revision 1.30
diff -u -r1.30 ct_sync_main.c
--- ct_sync_main.c	13 Jul 2004 14:53:41 -0000	1.30
+++ ct_sync_main.c	15 Jul 2004 14:14:58 -0000
@@ -164,6 +164,9 @@
 	hdr->resource = CT_SYNC_RES_CONNTRACK;
 	hdr->len = __constant_htons(sizeof(*sct));
 
+	memset(&sct->orig, 0, sizeof(struct ip_conntrack_tuple));
+	memset(&sct->reply, 0, sizeof(struct ip_conntrack_tuple));
+
 	/* copy data from conntrack struct */
 	memcpy(&sct->orig, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, 
 		sizeof(sct->orig));

--------------040103050700030701020901--
