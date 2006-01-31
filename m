From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC] [NETFILTER] nf_conntrack: clean up to reduce size of
 'struct nf_conn'
Date: Tue, 31 Jan 2006 14:09:42 +0900 (JST)
Message-ID: <200601310509.k0V59gV0017350@toshiba.co.jp>
References: <20060130232644.GI4603@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060130232644.GI4603@sunbeam.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 31 Jan 2006 00:26:44 +0100

> Hi Yasuyuki!
> 
> Please review the following patch.  I'm currently working on
> nf_conntrack based NAT, and this patch is a minor preparation to it.

Great!

> It mainly reworks the 'features' to be like I originally intended them to
> be.
>
> I've tested it with the ftp helper, and it seems to work fine.
> 
> Looking forward to receiving your comments.  If there's no objection,
> I'll push it to Dave soon.

Totally no objection. Some comments are...

- nice cleanup. But I don't know trade off between
	- calculate the pointer to help at initialization and keep it.
  and
	- don't keep the pointer for dieting. Instead re-calculate
	  when it's necessary.

  Then let's use your patch and we can change just only nf_conn_help()
  if and when necessary.

- Just question. How will you make conntrack keep the pointer to
  NAT related area ?

- minor fixes are as follows.

> @@ -842,8 +836,9 @@ __nf_conntrack_alloc(const struct nf_con
>  {
>  	struct nf_conn *conntrack = NULL;
>  	u_int32_t features = 0;
> +	void *helper;

'struct nf_conntrack_helper *helper' ?

> @@ -1309,8 +1291,7 @@ int nf_conntrack_helper_register(struct 
>  	ret = nf_conntrack_register_cache(NF_CT_F_HELP, "nf_conntrack:help",
>  					  sizeof(struct nf_conn)
>  					  + sizeof(union nf_conntrack_help)
> -					  + __alignof__(union nf_conntrack_help),
> -					  init_conntrack_for_helper);
> +					  + __alignof__(union nf_conntrack_help));

The 3rd argument should be
	sizeof(struct nf_conn) + __alignof__(struct nf_conn_help)


> @@ -165,15 +165,16 @@ static inline int
>  ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
>  {
>  	struct nfattr *nest_helper;
> +	const struct nf_conn_help *help = nfct_help(ct);
>  
> -	if (!ct->helper)
> +	if (!help)
>  		return 0;

I think checking "!help->helper" is necessary, too.
Even if nf_conntrack_helper_unregister() is called, nfct_help(ct) will returns
the valid pointer after that. But help->helper will be NULL.

-- Yasuyuki Kozakai
