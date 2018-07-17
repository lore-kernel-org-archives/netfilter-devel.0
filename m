From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to per-namespace
Date: Tue, 17 Jul 2018 10:40:09 -0700
Message-ID: <CAM_iQpW4g2v6xk49Gz+WBasKaO9VUk3Q-umX7iBRK-mAhn21Fw@mail.gmail.com>
References: <20180717120651.15748-1-dsahern@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        nikita.leshchenko@oracle.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
To: dsahern@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717120651.15748-1-dsahern@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 17, 2018 at 5:11 AM <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Nikita Leshenko reported that neighbor entries in one namespace can
> evict neighbor entries in another. The problem is that the neighbor
> tables have entries across all namespaces without separate accounting
> and with global limits on when to scan for entries to evict.

It is nothing new, people including me already noticed this before.


>
> Resolve by making the neighbor tables for ipv4, ipv6 and decnet per
> namespace and making the accounting and threshold limits per namespace.


The last discussion about this a long time ago concluded that neigh
table entries are controllable by remote, so after moving it to per netns,
it would be easier to DOS the host.
