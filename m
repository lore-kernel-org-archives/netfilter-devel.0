From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: check if the socket netns is correct.
Date: Fri, 28 Sep 2018 10:33:00 +0200
Message-ID: <20180928083300.q6xz2vbibm7jipws@salvia>
References: <20180927204629.GA4680@roeck-us.net>
 <20180927225824.GT2702@plex.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guenter Roeck <linux@roeck-us.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927225824.GT2702@plex.lan>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 27, 2018 at 07:58:24PM -0300, Flavio Leitner wrote:
[...]
> From a5f927e7f1368d753f87cb978d630d786d5adb62 Mon Sep 17 00:00:00 2001
> From: Flavio Leitner <fbl@redhat.com>
> Date: Thu, 27 Sep 2018 19:36:28 -0300
> Subject: [PATCH] xt_socket: check sk before checking for netns.
> 
> Only check for the network namespace if the socket is available.

Applied.

Please, Cc netfilter-devel@vger.kernel.org next time for your
netfilter patches.

Thanks.
