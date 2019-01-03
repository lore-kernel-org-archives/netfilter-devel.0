From: William Kucharski <william.kucharski@oracle.com>
Subject: Re: [PATCH v2] netfilter: account ebt_table_info to kmemcg
Date: Thu, 3 Jan 2019 03:14:56 -0700
Message-ID: <313C6566-289D-4973-BB15-857EED858DA3@oracle.com>
References: <20190103031431.247970-1-shakeelb@google.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
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
To: Shakeel Butt <shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190103031431.247970-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



> On Jan 2, 2019, at 8:14 PM, Shakeel Butt <shakeelb@google.com> wrote:
>=20
> 	countersize =3D COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
> -	newinfo =3D vmalloc(sizeof(*newinfo) + countersize);
> +	newinfo =3D __vmalloc(sizeof(*newinfo) + countersize, =
GFP_KERNEL_ACCOUNT,
> +			    PAGE_KERNEL);
> 	if (!newinfo)
> 		return -ENOMEM;
>=20
> 	if (countersize)
> 		memset(newinfo->counters, 0, countersize);
>=20
> -	newinfo->entries =3D vmalloc(tmp.entries_size);
> +	newinfo->entries =3D __vmalloc(tmp.entries_size, =
GFP_KERNEL_ACCOUNT,
> +				     PAGE_KERNEL);
> 	if (!newinfo->entries) {
> 		ret =3D -ENOMEM;
> 		goto free_newinfo;
> --=20

Just out of curiosity, what are the actual sizes of these areas in =
typical use
given __vmalloc() will be allocating by the page?

   =20
