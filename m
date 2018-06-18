From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: ipv6: nf_defrag: reduce struct net memory
 waste
Date: Mon, 18 Jun 2018 14:14:11 +0200
Message-ID: <20180618121411.mrbrmhntymfvteb2@salvia>
References: <20180613171156.240889-1-edumazet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613171156.240889-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 13, 2018 at 10:11:56AM -0700, Eric Dumazet wrote:
> It is a waste of memory to use a full "struct netns_sysctl_ipv6"
> while only one pointer is really used, considering netns_sysctl_ipv6
> keeps growing.
> 
> Also, since "struct netns_frags" has cache line alignment,
> it is better to move the frags_hdr pointer outside, otherwise
> we spend a full cache line for this pointer.
> 
> This saves 192 bytes of memory per netns.

Also applied, thanks.
