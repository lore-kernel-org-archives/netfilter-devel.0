From: Sasha Levin <sashal@kernel.org>
Subject: Re: stable regression: revert request for netfilter ipv6 defrag bug
Date: Wed, 31 Oct 2018 11:07:53 -0400
Message-ID: <20181031150753.GR194472@sasha-vm>
References: <20181024103104.72liko3nrf4pqwqa@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: stable@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181024103104.72liko3nrf4pqwqa@breakpoint.cc>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 24, 2018 at 12:31:04PM +0200, Florian Westphal wrote:
>Hi,
>
>please consider reverting
>
>commit 84379c9afe011020e797e3f50a662b08a6355dcf
>netfilter: ipv6: nf_defrag: drop skb dst before queueing
>
>It causes kernel crash for locally generated ipv6 fragments
>when netfilter ipv6 defragmentation is used.
>
>The faulty commit is not essential for -stable, it only
>delays netns teardown for longer than needed when that netns
>still has ipv6 frags queued.  Much better than crash :-/
>
>commit ids are:
>4.4.y: not affected (not backported)
>4.9.y: backported as ad8b1ffc3efae2f65080bdb11145c87d299b8f9a
>4.14.y: backported as 28c74ff85efd192aeca9005499ca50c24d795f61
>4.18.y: (first affected kernel): 84379c9afe011020e797e3f50a662b08a6355dcf
>
>For 4.19.y, you could also wait for a bug fix to hit Linus tree,
>I can ping you again once its in:
>https://patchwork.ozlabs.org/patch/988233/

I've queued a revert for 4.18, 4.14, and 4.9. Thank you.
