From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] conntrack ftp helper modification to use new
	infrastrure
Date: Mon, 10 Jan 2005 00:20:27 +0100
Message-ID: <41E1BC3B.5070101@trash.net>
References: <41E1AEEF.9050005@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41E1AEEF.9050005@eurodev.net>
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

Pablo Neira wrote:

> Attached the modifications for the ftp helper to use the functions 
> provided with the new infrastructure.
>
> Two important notes:
>
> * I must confess that I don't see the point of using the new 
> infrastructure at all for the ftp helper (no way, I didn't drive nuts, 
> not yet :o) but I see that it could be useful for the amanda helper 
> which does a strstr search. So, please consider this just an example, 
> read and drop it to /dev/null.
> * This doesn't apply on top of lastest rusty's helper simplifications.
>
> -- 
> Pablo
>
>------------------------------------------------------------------------
>
>===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.24 vs edited =====
>--- 1.24/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-10-20 10:12:06 +02:00
>+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-09 21:57:27 +01:00
>@@ -20,17 +20,17 @@
> #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
> #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
> #include <linux/moduleparam.h>
>+#include <linux/netfilter_ipv4/nf_string_match.h>
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
> MODULE_DESCRIPTION("ftp connection tracking helper");
> 
>-/* This is slow, but it's simple. --RR */
>-static char ftp_buffer[65536];
>-
> static DECLARE_LOCK(ip_ftp_lock);
> struct module *ip_conntrack_ftp = THIS_MODULE;
> 
>+#define FTP_BUFSIZE 64
>+
> #define MAX_PORTS 8
> static int ports[MAX_PORTS];
> static int ports_c;
>@@ -56,30 +56,35 @@
> 	char skip;
> 	char term;
> 	enum ip_ct_ftp_type ftptype;
>+	struct nf_string_match *sm;
>  
>

Why is is part of struct ftpsearch ? One struct nf_string_match per helper
should be enough as long as we take the global lock.

Regards
Patrick
