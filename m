From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH] netfilter: delete /proc THIS_MODULE references
Date: Mon, 15 Jan 2018 21:41:50 +0200 (EET)
Message-ID: <alpine.LFD.2.20.1801152139540.2045@ja.home.ssi.bg>
References: <20180113170831.GA1016@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:54018 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750773AbeAOUWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 15:22:44 -0500
In-Reply-To: <20180113170831.GA1016@avx2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


	Hello,

On Sat, 13 Jan 2018, Alexey Dobriyan wrote:

> /proc has been ignoring struct file_operations::owner field for ages.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

	IPVS part looks good to me.

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
> 
>  net/netfilter/ipvs/ip_vs_app.c          |    1 -
>  net/netfilter/ipvs/ip_vs_conn.c         |    2 --
>  net/netfilter/ipvs/ip_vs_ctl.c          |    3 ---
>  net/netfilter/nf_conntrack_expect.c     |    1 -
>  net/netfilter/nf_conntrack_standalone.c |    2 --
>  net/netfilter/nf_log.c                  |    1 -
>  net/netfilter/nf_synproxy_core.c        |    1 -
>  net/netfilter/nfnetlink_log.c           |    1 -
>  net/netfilter/nfnetlink_queue.c         |    1 -
>  net/netfilter/x_tables.c                |    3 ---
>  net/netfilter/xt_hashlimit.c            |    3 ---
>  11 files changed, 19 deletions(-)
> 
> --- a/net/netfilter/ipvs/ip_vs_app.c
> +++ b/net/netfilter/ipvs/ip_vs_app.c
> @@ -595,7 +595,6 @@ static int ip_vs_app_open(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations ip_vs_app_fops = {
> -	.owner	 = THIS_MODULE,
>  	.open	 = ip_vs_app_open,
>  	.read	 = seq_read,
>  	.llseek  = seq_lseek,
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1143,7 +1143,6 @@ static int ip_vs_conn_open(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations ip_vs_conn_fops = {
> -	.owner	 = THIS_MODULE,
>  	.open    = ip_vs_conn_open,
>  	.read    = seq_read,
>  	.llseek  = seq_lseek,
> @@ -1221,7 +1220,6 @@ static int ip_vs_conn_sync_open(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations ip_vs_conn_sync_fops = {
> -	.owner	 = THIS_MODULE,
>  	.open    = ip_vs_conn_sync_open,
>  	.read    = seq_read,
>  	.llseek  = seq_lseek,
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -2116,7 +2116,6 @@ static int ip_vs_info_open(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations ip_vs_info_fops = {
> -	.owner	 = THIS_MODULE,
>  	.open    = ip_vs_info_open,
>  	.read    = seq_read,
>  	.llseek  = seq_lseek,
> @@ -2161,7 +2160,6 @@ static int ip_vs_stats_seq_open(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations ip_vs_stats_fops = {
> -	.owner = THIS_MODULE,
>  	.open = ip_vs_stats_seq_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,
> @@ -2230,7 +2228,6 @@ static int ip_vs_stats_percpu_seq_open(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations ip_vs_stats_percpu_fops = {
> -	.owner = THIS_MODULE,
>  	.open = ip_vs_stats_percpu_seq_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,

Regards

--
Julian Anastasov <ja@ssi.bg>
