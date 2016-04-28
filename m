From: Charlemagne Lasse <charlemagnelasse@gmail.com>
Subject: Re: [nf-next, 1/2] netfilter: conntrack: cache route for forwarded connections
Date: Thu, 28 Apr 2016 10:05:28 +0200
Message-ID: <CAFGhKbxZU+zHwnyJmodLL9xcUUprqxiAQBd3zjjJThRX1r==yw@mail.gmail.com>
References: <1418052964-4632-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	brouer@redhat.com, davem@davemloft.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1418052964-4632-2-git-send-email-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

2014-12-08 16:36 GMT+01:00 Florian Westphal <fw@strlen.de>:
> ... to avoid per-packet FIB lookup if possible.
>
> The cached dst is re-used provided the input interface
> is the same as that of the previous packet in the same direction.
>
> If not, the cached dst is invalidated.

It looks like someone found out that this patch causes crashes. This
was reported to OpenWrt in ticket https://dev.openwrt.org/ticket/22283
