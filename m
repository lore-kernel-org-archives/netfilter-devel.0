From: =?gb2312?B?uN+35Q==?= <fgao@ikuai8.com>
Subject: RE: 4.12 nf_conntrack_expect crash
Date: Tue, 18 Jul 2017 08:23:26 +0800
Message-ID: <000301d2ff5c$135cab00$3a160100$@ikuai8.com>
References: <2194e012-5a89-54f0-db46-ff9ce6aa3953@suse.cz> <12e1fdf4-2936-d2a7-e537-1038fbf5b7a3@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 7bit
Cc: <kadlec@blackhole.kfki.hu>, "'Florian Westphal'" <fw@strlen.de>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        "'Linux kernel mailing list'" <linux-kernel@vger.kernel.org>
To: "'Jiri Slaby'" <jslaby@suse.cz>,
        "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:49336 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751383AbdGRAXi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 20:23:38 -0400
In-Reply-To: <12e1fdf4-2936-d2a7-e537-1038fbf5b7a3@suse.cz>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jiri,

> From: Jiri Slaby [mailto:jslaby@suse.cz]
> Subject: Re: 4.12 nf_conntrack_expect crash
> 
> On 07/17/2017, 04:49 PM, Jiri Slaby wrote:
> > Hi,
> >
> > on my system, I see a crash in del_timer invoked in nf_conntrack_expect.
> > See the attached picture.
> >
> > I somehow suspect this commit:
> >
> > commit ec0e3f01114ad327112432a4da8840eb22fed577
> > Author: Gao Feng <fgao@ikuai8.com>
> > Date:   Mon Mar 27 10:31:26 2017 +0800
> >
> >     netfilter: nf_ct_expect: Add nf_ct_remove_expect()
> >
> >
> > I am going to play with it (debug, try to revert, etc.) if you have no
> > better idea...
> 
> This?
> 
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -422,7 +422,7 @@ static inline int __nf_ct_expect_check(struct
> nf_conntrack_expect *expect)
>         h = nf_ct_expect_dst_hash(net, &expect->tuple);
>         hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
>                 if (expect_matches(i, expect)) {
> -                       if (nf_ct_remove_expect(expect))
> +                       if (nf_ct_remove_expect(i))
>                                 break;
>                 } else if (expect_clash(i, expect)) {
>                         ret = -EBUSY;
> 
> 
> 
> >
> > thanks,
> >
> 
> 
> --
> js
> suse labs

It is a bug caused by typo indeed. I am sorry about that.
And Florian has fixed it recently, but thanks your catch again.

Regards
Feng




