From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack_core: port to module_param
Date: Mon, 18 Oct 2004 06:31:52 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410172131.i9HLVrVF010252@toshiba.co.jp>
References: <200410160010.40500.michal@rokos.info>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: michal@rokos.info
In-Reply-To: <200410160010.40500.michal@rokos.info>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Michal,

As I said at usagi-users ML, I have already started synchronizing nf_conntrack
with ip_conntrack in linux 2.9.6-rc4, and already done same changes in your
patch.

By the way, I reviewed your patches sent to usagi-users ML.
	- 3 patches to introduce seq_file API.
	- a patch to introduce module_param to ftp module.

They were almost fine for me, and applied them. Thank you!
Then could you send your Signed-off-by ?

And, I'm changing many parts and afraid of double work. After more some
changes and tests, I'll send the latest nf_conntrack (or commit it to tree
in netfilter site). I use the branch for nf_conntrack in USAGI tree as
snapshot only. Moreover, I think that almost people check nf_conntrack
in only netfilter site.

So, could you wait for a while to prevent double work and use nf_conntrack
in netfilter site if you want to make patches ?

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


From: Michal Rokos <michal@rokos.info>
Date: Sat, 16 Oct 2004 00:10:40 +0200

> Hello,
> 
> as Yasuyuki KOZAKAI directed, I'm sending nf_conntrack patches here 
> instead of usagi-users.
> 
> This one is 1 addition I forget to fold into last patch I sent.
> 
> Make nf_conntrack_core use module_param() and turn of debugging by 
> default.
> 
> Michal
> 
> # This is a BitKeeper generated diff -Nru style patch.
> #
> # ChangeSet
> #   2004/10/15 23:52:28+02:00 michal@michal.rokos.info 
> #   Forgot to port nf_conntrack_core to module_param too.
> # 
> # net/netfilter/nf_conntrack_core.c
> #   2004/10/15 23:52:17+02:00 michal@michal.rokos.info +2 -2
> #   Port nf_conntrack_core to module_param too.
> # 
> diff -Nru a/net/netfilter/nf_conntrack_core.c 
> b/net/netfilter/nf_conntrack_core.c
> --- a/net/netfilter/nf_conntrack_core.c 2004-10-16 00:07:30 +02:00
> +++ b/net/netfilter/nf_conntrack_core.c 2004-10-16 00:07:30 +02:00
> @@ -53,7 +53,7 @@
>  
>  #define NF_CONNTRACK_VERSION "0.3"
>  
> -#if 1
> +#if 0
>  #define DEBUGP printk
>  #else
>  #define DEBUGP(format, args...)
> @@ -1653,7 +1653,7 @@
>  }
>  
>  static int hashsize;
> -MODULE_PARM(hashsize, "i");
> +module_param(hashsize, int, 0400);
>  
>  int __init nf_conntrack_init(void)
>  {
> 
> 
