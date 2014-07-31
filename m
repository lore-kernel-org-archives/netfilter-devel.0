From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2 v2 net-next] netfilter: xt_bpf: add mising opaque
 struct sk_filter definition
Date: Wed, 30 Jul 2014 19:57:04 -0700 (PDT)
Message-ID: <20140730.195704.1972856285516371876.davem@davemloft.net>
References: <1406650335-5916-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	ast@plumgrid.com, keescook@chromium.org, willemb@google.com,
	dborkman@redhat.com
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1406650335-5916-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 29 Jul 2014 18:12:15 +0200

> This structure is not exposed to userspace, so fix this by defining
> struct sk_filter; so we skip the casting in kernelspace. This is safe
> since userspace has no way to lurk with that internal pointer.
> 
> Fixes: e6f30c7 ("netfilter: x_tables: add xt_bpf match")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: address Willem's feedback, we still need uapi/linux/filter.h for
>     userspace iptables builds.

Applied.
