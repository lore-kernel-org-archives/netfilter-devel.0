From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net, netfilter: refcounter conversions
Date: Fri, 17 Mar 2017 12:50:58 +0100
Message-ID: <20170317115058.GB4979@salvia>
References: <1489651414-27511-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kadlec@blackhole.kfki.hu, peterz@infradead.org,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
To: Elena Reshetova <elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489651414-27511-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Mar 16, 2017 at 10:03:34AM +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API (see include/linux/refcount.h)
> should be used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.

Applied, thanks.
