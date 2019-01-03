From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2] netfilter: account ebt_table_info to kmemcg
Date: Thu, 3 Jan 2019 08:18:09 -0800
Message-ID: <CALvZod5YSKZvWq13ptbfignECxLVH5H_1YbdvoghrmicuDwuSA@mail.gmail.com>
References: <20190103031431.247970-1-shakeelb@google.com> <313C6566-289D-4973-BB15-857EED858DA3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Westphal <fw@strlen.de>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+7713f3aa67be76b1552c@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
To: William Kucharski <william.kucharski@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <313C6566-289D-4973-BB15-857EED858DA3@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 3, 2019 at 2:15 AM William Kucharski
<william.kucharski@oracle.com> wrote:
>
>
>
> > On Jan 2, 2019, at 8:14 PM, Shakeel Butt <shakeelb@google.com> wrote:
> >
> >       countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
> > -     newinfo = vmalloc(sizeof(*newinfo) + countersize);
> > +     newinfo = __vmalloc(sizeof(*newinfo) + countersize, GFP_KERNEL_ACCOUNT,
> > +                         PAGE_KERNEL);
> >       if (!newinfo)
> >               return -ENOMEM;
> >
> >       if (countersize)
> >               memset(newinfo->counters, 0, countersize);
> >
> > -     newinfo->entries = vmalloc(tmp.entries_size);
> > +     newinfo->entries = __vmalloc(tmp.entries_size, GFP_KERNEL_ACCOUNT,
> > +                                  PAGE_KERNEL);
> >       if (!newinfo->entries) {
> >               ret = -ENOMEM;
> >               goto free_newinfo;
> > --
>
> Just out of curiosity, what are the actual sizes of these areas in typical use
> given __vmalloc() will be allocating by the page?
>

We don't really use this in production, so, I don't have a good idea
of the size in the typical case. The size depends on the workload. The
motivation behind this patch was the system OOM triggered by a syzbot
running in a restricted memcg.

Shakeel
