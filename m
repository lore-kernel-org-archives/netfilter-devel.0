From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 21 Jun 2005 16:00:21 +0200
Message-ID: <42B81D75.8090205@trash.net>
References: <42A57FC4.7010508@tac.ch>
	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>
	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>
	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>
	<20050621111328.GK8335@postel.suug.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020900070902080801030004"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050621111328.GK8335@postel.suug.ch>
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
--------------020900070902080801030004
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Thomas Graf wrote:
>>If the module gets unloaded, ip_conntrack_untracked refcount isn't 
>>decreased, it's still 1. So destroy() is never called. In that case it 
>>should be really easy to trigger on my slow laptop ;->.
> 
> How do you explain the BUG() being triggered then?

Pablo mentioned to me in private mail that he believes the reason
is packets holding references to ip_conntrack_untracked on module
removal. I agree, and this patch should fix it. Roberto, could
you please try it and tell me if it helps?

Regards
Patrick

--------------020900070902080801030004
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1111,7 +1111,9 @@ void ip_conntrack_cleanup(void)
 		schedule();
 		goto i_see_dead_people;
 	}
-
+	/* wait until all references to ip_conntrack_untracked are dropped */
+	while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
+		schedule();
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	free_conntrack_hash();

--------------020900070902080801030004--
