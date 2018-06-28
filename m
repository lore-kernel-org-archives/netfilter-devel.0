From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 0/2] net: preserve sock reference when
 scrubbing the skb.
Date: Thu, 28 Jun 2018 22:20:40 +0900 (KST)
Message-ID: <20180628.222040.2117056805629988850.davem@davemloft.net>
References: <20180627133426.3858-1-fbl@redhat.com>
        <CAM_iQpXnfc8uA10EK2X7B=vB_uWayeGw=M5F-_uygu7aPvCjRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: fbl@redhat.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        pabeni@redhat.com, fw@strlen.de, netfilter-devel@vger.kernel.org
To: xiyou.wangcong@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpXnfc8uA10EK2X7B=vB_uWayeGw=M5F-_uygu7aPvCjRw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 27 Jun 2018 12:39:01 -0700

> Let me rephrase why I don't like this patchset:

Cong, I don't think you are seeing the situation clearly and
I am certainly going to apply this patch series even in the
face of your objections.

Suggesting that solving the lack of back pressure on a UDP
socket caused by this problem by using cgroups or cpu
usage controllers is just complete and utter madness.
