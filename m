From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/7] net, netfilter refcounter conversions
Date: Wed, 15 Mar 2017 14:02:13 +0100
Message-ID: <20170315130213.GA30233@salvia>
References: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kadlec@blackhole.kfki.hu, peterz@infradead.org,
        keescook@chromium.org
To: Elena Reshetova <elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Mar 15, 2017 at 01:10:38PM +0200, Elena Reshetova wrote:
> This series, for the netfilter subsystem, replaces atomic_t reference
> counters with the new refcount_t type and API (see include/linux/refcount.h).
> By doing this we prevent intentional or accidental
> underflows or overflows that can led to use-after-free vulnerabilities.
> 
> Please take the series to your tree if there are no run-time issues.

Could you collapse all of your patches into one single? They are all
part of the same logical change to me.

>  21 files changed, 85 insertions(+), 75 deletions(-)

The diffstat is small enough to do what I'm asking.

Thanks!
