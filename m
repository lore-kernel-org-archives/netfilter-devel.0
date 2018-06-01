From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nfnetlink: Remove VLA usage
Date: Fri, 1 Jun 2018 09:48:04 +0200
Message-ID: <20180601074804.44l66hj7lcwhpdmv@salvia>
References: <20180530191756.GA39504@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530191756.GA39504@beast>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 30, 2018 at 12:17:56PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> allocates the maximum size expected for all possible attrs and adds
> sanity-checks at both registration and usage to make sure nothing
> gets out of sync.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Applied, thanks Kees.
