From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ROUTE target missing newline
Date: Fri, 06 Aug 2004 14:57:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41138035.5060001@trash.net>
References: <20040805233608.GA5166@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040805233608.GA5166@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>The below patch fixes the ROUTE target ipv6 breakage noted in 
>bugzilla #218
>  
>
Applied, thanks.


>
>Phil
>
>
>diff -ru pom-orig/ROUTE/linux/net/ipv6/netfilter/Config.in.ladd pom-new/ROUTE/linux/net/ipv6/netfilter/Config.in.ladd
>--- pom-orig/ROUTE/linux/net/ipv6/netfilter/Config.in.ladd      2003-12-20 11:43:09.000000000 -0500
>+++ pom-new/ROUTE/linux/net/ipv6/netfilter/Config.in.ladd       2004-08-05 19:31:43.855304984 -0400
>@@ -1,2 +1,2 @@
>     dep_tristate '    MARK target support' CONFIG_IP6_NF_TARGET_MARK $CONFIG_IP6_NF_MANGLE
>-    dep_mbool '    ROUTE target support' CONFIG_IP6_NF_TARGET_ROUTE $CONFIG_IP6_NF_MANGLE
>\ No newline at end of file
>+    dep_mbool '    ROUTE target support' CONFIG_IP6_NF_TARGET_ROUTE $CONFIG_IP6_NF_MANGLE
>
>  
>
