From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] netfilter: x_tables: fix missing unlock if table init
 fails
Date: Fri, 12 Oct 2018 16:35:17 -0700
Message-ID: <20181012233517.GA21784@vader>
References: <32ddddccb89d8be6a73cd2de2fb20283b2ef6a94.1539385788.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-team@fb.com
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32ddddccb89d8be6a73cd2de2fb20283b2ef6a94.1539385788.git.osandov@fb.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 12, 2018 at 04:16:53PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Commit 7dde07e9c536 ("netfilter: x_tables: unlock on error in
> xt_find_table_lock()") fixed one missing unlock in xt_find_table_lock(),
> but we're also missing one if t->table_init() fails.
> 
> Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Whoops, please ignore this, I missed the unlock right before the
table_init call...
