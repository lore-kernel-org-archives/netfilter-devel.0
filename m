From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: [PATCH 04/15] [NETFILTER]: Use proc_create() to setup ->proc_fops
 first
Date: Fri, 29 Feb 2008 13:30:35 +0100
Message-ID: <47C7FAEB.7060908@trash.net>
References: <20080228.140543.209766510.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020700080002060307090003"
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Wang Chen <wangchen@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep31-int.chello.at ([62.179.121.49]:55110 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854AbYB2May (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:30:54 -0500
In-Reply-To: <20080228.140543.209766510.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020700080002060307090003
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> Use proc_create() and proc_net_fops_create() to
> make sure that ->proc_fops be setup before gluing
> PDE to main tree.
> 
> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
> ---

> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -162,19 +162,16 @@ clusterip_config_init(struct ipt_clusterip_tgt_info *i, __be32 ip,
>  	atomic_set(&c->entries, 1);
>  
>  #ifdef CONFIG_PROC_FS
> -	{
> -		char buffer[16];
> -
> -		/* create proc dir entry */
> -		sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
> -		c->pde = create_proc_entry(buffer, S_IWUSR|S_IRUSR,
> -					   clusterip_procdir);
> -		if (!c->pde) {
> -			kfree(c);
> -			return NULL;
> -		}
> +	char buffer[16];


Applied with this change on top to fix a compiler warning:

net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_config_init':
net/ipv4/netfilter/ipt_CLUSTERIP.c:165: warning: ISO C90 forbids mixed 
declarations and code


--------------020700080002060307090003
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index af44818..c20383e 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -162,17 +162,19 @@ clusterip_config_init(struct ipt_clusterip_tgt_info *i, __be32 ip,
 	atomic_set(&c->entries, 1);
 
 #ifdef CONFIG_PROC_FS
-	char buffer[16];
-
-	/* create proc dir entry */
-	sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
-	c->pde = proc_create(buffer, S_IWUSR|S_IRUSR,
-			     clusterip_procdir, &clusterip_proc_fops);
-	if (!c->pde) {
-		kfree(c);
-		return NULL;
+	{
+		char buffer[16];
+
+		/* create proc dir entry */
+		sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
+		c->pde = proc_create(buffer, S_IWUSR|S_IRUSR,
+				     clusterip_procdir, &clusterip_proc_fops);
+		if (!c->pde) {
+			kfree(c);
+			return NULL;
+		}
+		c->pde->data = c;
 	}
-	c->pde->data = c;
 #endif
 
 	write_lock_bh(&clusterip_lock);

--------------020700080002060307090003--
