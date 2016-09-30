From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v4 2/2] nf_set_hooks_head: accommodate different
 kconfig
Date: Fri, 30 Sep 2016 19:43:16 +0200
Message-ID: <20160930174316.GD1176@salvia>
References: <1475076915-5920-1-git-send-email-aconole@bytheb.org>
 <1475076915-5920-3-git-send-email-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475076915-5920-3-git-send-email-aconole@bytheb.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 28, 2016 at 11:35:15AM -0400, Aaron Conole wrote:
> When CONFIG_NETFILTER_INGRESS is unset (or no), we need to handle
> the request for registration properly by dropping the hook.  This
> releases the entry during the set.

Also applied.

I have renamed the subject to:

        netfilter: accommodate different kconfig in nf_set_hooks_head()

to make it look similar to what we have in the history.

Thanks.
