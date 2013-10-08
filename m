From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] nfnetlink: use rcu_assign_pointer in
 nfnetlink_subsys_unregister
Date: Tue, 08 Oct 2013 08:23:54 -0700
Message-ID: <1381245834.12191.37.camel@edumazet-glaptop.roam.corp.google.com>
References: <1381226648-10959-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:33480 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3JHPYI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:24:08 -0400
Received: by mail-yh0-f44.google.com with SMTP id f64so2119911yha.31
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Oct 2013 08:24:07 -0700 (PDT)
In-Reply-To: <1381226648-10959-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2013-10-08 at 18:04 +0800, Gao feng wrote:
> Though I don't face an oops, but it is more safer to
> set table's subsys through rcu_assign_pointer.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  net/netfilter/nfnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 572d87d..3cd2fe6 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
>  int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n)
>  {
>  	nfnl_lock(n->subsys_id);
> -	table[n->subsys_id].subsys = NULL;
> +	rcu_assign_pointer(table[n->subsys_id].subsys, NULL);
>  	nfnl_unlock(n->subsys_id);
>  	synchronize_rcu();
>  	return 0;

Certainly not.

Assigning a NULL pointer do not require rcu_assign_pointer() but this,
if you want to be really really clean.

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 572d87d..649958b 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
 int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n)
 {
 	nfnl_lock(n->subsys_id);
-	table[n->subsys_id].subsys = NULL;
+	RCU_INIT_POINTER(table[n->subsys_id].subsys, NULL);
 	nfnl_unlock(n->subsys_id);
 	synchronize_rcu();
 	return 0;




