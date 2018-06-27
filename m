From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 net-next 1/2] netfilter: check if the socket netns is
 correct.
Date: Wed, 27 Jun 2018 16:22:22 +0200
Message-ID: <20180627142222.vzipwze4k4aebqay@breakpoint.cc>
References: <20180627133426.3858-1-fbl@redhat.com>
 <20180627133426.3858-2-fbl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
To: Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180627133426.3858-2-fbl@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Flavio Leitner <fbl@redhat.com> wrote:
> Netfilter assumes that if the socket is present in the skb, then
> it can be used because that reference is cleaned up while the skb
> is crossing netns.
>
> We want to change that to preserve the socket reference in a future
> patch, so this is a preparation updating netfilter to check if the
> socket netns matches before use it.

Acked-by: Florian Westphal <fw@strlen.de>
