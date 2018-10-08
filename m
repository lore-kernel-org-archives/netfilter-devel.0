From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_quota: Allow setting the
 remaining quota
Date: Tue, 9 Oct 2018 01:16:23 +0200
Message-ID: <20181008231623.wqlhz5zn3f2q3uxl@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-2-git-send-email-chenbofeng.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>,
        maze@google.com, Chenbo Feng <fengc@google.com>
To: Chenbo Feng <chenbofeng.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538443388-6881-2-git-send-email-chenbofeng.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 01, 2018 at 06:23:07PM -0700, Chenbo Feng wrote:
> From: Chenbo Feng <fengc@google.com>
> 
> The current xt_quota module cannot track the current remaining quota
> of a specific rule. Everytime an unrelated rule is updated in the same
> iptables table, the quota will be reset. This is not a very useful
> function for iptables that get changed at run time. This patch fixes the
> above problem by adding a new field in the struct that records the
> current remaining quota.
> 
> Fixed a print out bug in verbose print out wrt. inversion.

Applied, thanks.

Please, send me a patch to:

#1 add tests for iptables-tests.py, see .t file under extensions/
#2 document this new option in the manpage.

Thanks again.
