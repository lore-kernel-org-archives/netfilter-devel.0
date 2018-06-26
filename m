From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: nf_log: don't hold nf_log_mutex during
 user access
Date: Tue, 26 Jun 2018 18:05:15 +0200
Message-ID: <20180626160515.erczjbfvhauqlyfe@salvia>
References: <20180625152200.200145-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org
To: Jann Horn <jannh@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625152200.200145-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 25, 2018 at 05:22:00PM +0200, Jann Horn wrote:
> The old code would indefinitely block other users of nf_log_mutex if
> a userspace access in proc_dostring() blocked e.g. due to a userfaultfd
> region. Fix it by moving proc_dostring() out of the locked region.
> 
> This is a followup to commit 266d07cb1c9a ("netfilter: nf_log: fix
> sleeping function called from invalid context"), which changed this code
> from using rcu_read_lock() to taking nf_log_mutex.

Applied.
