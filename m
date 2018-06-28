From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: preserve sock reference when
 scrubbing the skb.
Date: Thu, 28 Jun 2018 14:41:16 -0700
Message-ID: <CAM_iQpW-Ggs5iHjshWiSbNArANsBK8JVY-Qt0Lw+m=sk4onzpw@mail.gmail.com>
References: <20180627133426.3858-1-fbl@redhat.com> <CAM_iQpXnfc8uA10EK2X7B=vB_uWayeGw=M5F-_uygu7aPvCjRw@mail.gmail.com>
 <20180628.222040.2117056805629988850.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Flavio Leitner <fbl@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180628.222040.2117056805629988850.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 28, 2018 at 6:20 AM David Miller <davem@davemloft.net> wrote:
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Wed, 27 Jun 2018 12:39:01 -0700
>
> > Let me rephrase why I don't like this patchset:
>
> Cong, I don't think you are seeing the situation clearly and
> I am certainly going to apply this patch series even in the
> face of your objections.
>
> Suggesting that solving the lack of back pressure on a UDP
> socket caused by this problem by using cgroups or cpu
> usage controllers is just complete and utter madness.

Pretty sure you didn't even read the rest of my reply,
I can't help you if you just stop at where you quoted.
