From: Pravin Shelar <pshelar@ovn.org>
Subject: Re: [PATCH nf-next v2] openvswitch: use nf_ct_get_tuplepr, invert_tuplepr
Date: Mon, 25 Jun 2018 20:46:45 -0700
Message-ID: <CAOrHB_A_S_+f_weEW-PhNkhKTLXM3NKvAXh82XRTgntMSyNAQA@mail.gmail.com>
References: <20180625155532.20577-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180625155532.20577-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 25, 2018 at 8:55 AM, Florian Westphal <fw@strlen.de> wrote:
> These versions deal with the l3proto/l4proto details internally.
> It removes only caller of nf_ct_get_tuple, so make it static.
>
> After this, l3proto->get_l4proto() can be removed in a followup patch.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
