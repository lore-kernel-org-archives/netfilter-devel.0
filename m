From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack tree
Date: Thu, 17 Mar 2005 04:22:16 +0900 (JST)
Message-ID: <200503161922.j2GJMGZE006465@toshiba.co.jp>
References: <42377F54.8070408@trash.net>
	<200503160648.j2G6mXVV014699@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	kaber@trash.net
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200503160648.j2G6mXVV014699@toshiba.co.jp>
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


Hi,

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Wed, 16 Mar 2005 15:48:33 +0900 (JST)

> 	2. I would not like to change UI. If ip_conntrack isn't loaded when
> 	   these matches/targets are loaded, I want kernel to load ip_conntrack
> 	   automatically. I suggests changes in init() as following.
> 
> 		int ret = -1;	   
> 
> 		if (get_symbols(need_ip_conntrack) != NULL) {
> 			ret = ip_register_match(match_func_with_ip_conntrack);
> 
> 		} else if (get_symbols(need_nf_conntrack) != NULL) {
> 			ret = ip_register_match(match_func_with_nf_conntrack);
> 		} else
> 			return -1;
> 
> 		return ret;
> 
> 	  I don't know this usage of get_symbols() is right or not.
> 	  If right, ip_conntrack will be loaded automatically in the case that
> 	  ip_conntrack and nf_conntrack are not loaded.
> 	  If either of them is loaded, it will be used.

Oh, this is bad code. What I really want to do is following.
Anyway, this issue would be resolved.

 static struct ipt_match helper_match = {
 	.name		= "helper",
-	.match		= &match,
 	.checkentry	= &check,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
-	need_ip_conntrack();
+	if (!request_module("ip_conntrack"))
+		helper_match.match = &ip_match;
+	} else if (!request_module("nf_conntrack"))
+		helper_match.match = &nf_match;
+	} else
+		return -1;
+
 	return ipt_register_match(&helper_match);
 }
 
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
