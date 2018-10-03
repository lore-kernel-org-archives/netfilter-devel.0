From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Wed, 3 Oct 2018 17:37:19 +0200
Message-ID: <20181003153719.ukchffiac7dr6qlt@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>,
        maze@google.com, Chenbo Feng <fengc@google.com>
To: Chenbo Feng <chenbofeng.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 01, 2018 at 06:23:08PM -0700, Chenbo Feng wrote:
> From: Chenbo Feng <fengc@google.com>
> 
> A major flaw of the current xt_quota module is that quota in a specific
> rule gets reset every time there is a rule change in the same table. It
> makes the xt_quota module not very useful in a table in which iptables
> rules are changed at run time. This fix introduces a new counter that is
> visible to userspace as the remaining quota of the current rule. When
> userspace restores the rules in a table, it can restore the counter to
> the remaining quota instead of resetting it to the full quota.

Applied, thanks.
