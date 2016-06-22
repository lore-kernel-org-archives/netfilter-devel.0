From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH -next v2] netfilter: conntrack: allow increasing bucket
 size via sysctl too
Date: Wed, 22 Jun 2016 18:47:11 +0800
Message-ID: <CAML_gOdXwCqxKAyUKmpcDfLky_kvn=5=GrkG+zmh9NUQHJVPcg@mail.gmail.com>
References: <1466534782-567-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:35882 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbcFVLAL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 07:00:11 -0400
Received: by mail-vk0-f68.google.com with SMTP id v188so7140343vkf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 03:59:19 -0700 (PDT)
In-Reply-To: <1466534782-567-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

2016-06-22 2:46 GMT+08:00 Florian Westphal <fw@strlen.de>:
> @@ -1650,11 +1646,31 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
>         write_seqcount_end(&nf_conntrack_generation);
>         nf_conntrack_all_unlock();
>         local_bh_enable();
> +       synchronize_net();

synchronize_net()  call here is redundant?

>
>         synchronize_net();
>         nf_ct_free_hashtable(old_hash, old_size);
>         return 0;
>  }

And according to your patch version 1, it seems that you missed to update the
Documentation/networking/nf_conntrack-sysctl.txt this time.
