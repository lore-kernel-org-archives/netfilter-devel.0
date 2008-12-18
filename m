From: "James King" <t.james.king@gmail.com>
Subject: Re: [PATCH 1/1 ] Conntrack extensions : Interrupt timeout
Date: Wed, 17 Dec 2008 18:36:35 -0800
Message-ID: <38bcb3ec0812171836r4c6161b2m1026d73722a72cfe@mail.gmail.com>
References: <49467ACC.8080107@trash.net>
	 <20081216.012018.196068498.davem@davemloft.net>
	 <49495F88.2010103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Piotr Duszynski" <regis44@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:34218 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYLRCgi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:36:38 -0500
Received: by ik-out-1112.google.com with SMTP id c29so48182ika.5
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2008 18:36:35 -0800 (PST)
In-Reply-To: <49495F88.2010103@gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 17, 2008 at 12:22 PM, Piotr Duszynski <regis44@gmail.com> wrote:
> I wanted to write a module that would track all the MAC information for
> all established connections. Unfortunately, after the module is loaded
> and all the information is being properly recorded to the conntrack
> computer hangs . I can read that it is related with interrupt timeout,
> but after several hours of trying to fix this I am still in the same
> spot . I would really appreciate any guidance in this matter .
>
> +               l2info = nfct_l2info(ct);
> +               if (!l2info) {
> +                       printk(KERN_INFO "Adding L2INFO extension\n");
> +                       l2info = nf_ct_ext_add(ct, NF_CT_EXT_L2INFO,GFP_ATOMIC);

You shouldn't call nf_ct_ext_add from within your target, as your
private structure needs to be added before the conntrack is confirmed
(preferably at allocation time).  From _nf_ct_ext_add() in
nf_conntrack_extend.c:

 /* Conntrack must not be confirmed to avoid races on reallocation. */
NF_CT_ASSERT(!nf_ct_is_confirmed(ct));

Take a look at init_conntrack() in nf_conntrack_core.c to see how
nf_conntrack_acct does it.  lxr.linux.no is your friend :)

HTH,
James
