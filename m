From: Nicolas Bouliane <nib@cookinglinux.org>
Subject: Re: [PATCH] ip_conntrack_ftp segfault
Date: Tue, 04 Jan 2005 13:45:41 -0500
Message-ID: <41DAE455.9090207@cookinglinux.org>
References: <41D99B6B.6050601@cookinglinux.org> <41DA715D.2080704@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000408060401000809010900"
Cc: Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <41DA715D.2080704@eurodev.net>
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
--------------000408060401000809010900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira wrote:
> nice catch, but read the comments below.

> Since this is a minor fix, try to modify as less things as you can. data 
> doesn't exist but look for its natural replacement which is fb_ptr.

Hey Pablo, thanks for the hints! :)

>> This patch fix two bugs (when DEBUGP is defined):
>> o The var `data` doesn't exist, hence gcc complains.
>> o It segfault because we print an integer with `%s`.

Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>



--------------000408060401000809010900
Content-Type: text/x-patch;
 name="ip_conntrack_ftp.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_ftp.c.patch"

--- linux-2.6.10/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-12-24 16:35:59.000000000 -0500
+++ linux-2.6.10NIB/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-04 13:24:35.000000000 -0500
@@ -347,10 +347,9 @@
 		goto out;
 	}
 
-	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
-	       (int)matchlen, data + matchoff,
-	       matchlen, ntohl(th->seq) + matchoff);
-
+	DEBUGP("conntrack_ftp: match `%s' (%u bytes at %u)\n",
+	       fb_ptr + matchoff, matchlen, ntohl(th->seq) + matchoff);
+			 
 	/* Allocate expectation which will be inserted */
 	exp = ip_conntrack_expect_alloc();
 	if (exp == NULL) {

--------------000408060401000809010900--
