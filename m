From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] netfilter: account ebt_table_info to kmemcg
Date: Sat, 29 Dec 2018 11:06:15 +0100
Message-ID: <20181229100615.GB16738@dhcp22.suse.cz>
References: <20181229015524.222741-1-shakeelb@google.com>
 <20181229073325.GZ16738@dhcp22.suse.cz>
 <20181229095215.nbcijqacw5b6aho7@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shakeel Butt <shakeelb@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        syzbot+7713f3aa67be76b1552c@syzkaller.appspotmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181229095215.nbcijqacw5b6aho7@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat 29-12-18 10:52:15, Florian Westphal wrote:
> Michal Hocko <mhocko@kernel.org> wrote:
> > On Fri 28-12-18 17:55:24, Shakeel Butt wrote:
> > > The [ip,ip6,arp]_tables use x_tables_info internally and the underlying
> > > memory is already accounted to kmemcg. Do the same for ebtables. The
> > > syzbot, by using setsockopt(EBT_SO_SET_ENTRIES), was able to OOM the
> > > whole system from a restricted memcg, a potential DoS.
> > 
> > What is the lifetime of these objects? Are they bound to any process?
> 
> No, they are not.
> They are free'd only when userspace requests it or the netns is
> destroyed.

Then this is problematic, because the oom killer is not able to
guarantee the hard limit and so the excessive memory consumption cannot
be really contained. As a result the memcg will be basically useless
until somebody tears down the charged objects by other means. The memcg
oom killer will surely kill all the existing tasks in the cgroup and
this could somehow reduce the problem. Maybe this is sufficient for
some usecases but that should be properly analyzed and described in the
changelog.

-- 
Michal Hocko
SUSE Labs
