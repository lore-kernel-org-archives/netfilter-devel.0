From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ip_conntrack_ftp segfault
Date: Tue, 04 Jan 2005 11:35:09 +0100
Message-ID: <41DA715D.2080704@eurodev.net>
References: <41D99B6B.6050601@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nicolas Bouliane <nib@cookinglinux.org>
In-Reply-To: <41D99B6B.6050601@cookinglinux.org>
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

nice catch, but read the comments below.

Nicolas Bouliane wrote:

> This patch fix two bugs (when DEBUGP is defined):
> o The var `data` doesn't exist, hence gcc complains.
> o It segfault because we print an integer with `%s`.
>
>------------------------------------------------------------------------
>
>--- /usr/src/old/linux-2.6.10/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-12-24 16:35:59.000000000 -0500
>+++ ip_conntrack_ftp.c	2005-01-03 14:09:06.000000000 -0500
>  
>

this header must always look like, for example:

--- linux-2.6.10/net/ipv4/netfilter/ip_conntrack_ftp.c  2004-10-20 
10:12:06 +02:00
+++ linux-2.6.10-nicolas/net/ipv4/netfilter/ip_conntrack_ftp.c        
2005-01-02 16:09:01 +01:00

>@@ -347,9 +347,8 @@
> 		goto out;
> 	}
> 
>-	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
>-	       (int)matchlen, data + matchoff,
>-	       matchlen, ntohl(th->seq) + matchoff);
>+	DEBUGP("conntrack_ftp: match `%s' (%u bytes at %u)\n",
>+			search[i].pattern, matchlen, ntohl(th->seq) + matchoff);
>  
>

Since this is a minor fix, try to modify as less things as you can. data 
doesn't exist but look for its natural replacement which is fb_ptr.

Rusty punish me yesterday to read part (11) of 
Documentation/SubmittingPatches in the kernel source tree :). So do it 
you as well and add your sign-off.

Resend a patch which fixes the things above. After that, let wait to see 
if Patrick wants to add this to his changeset 8).

--
Pablo
