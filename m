From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Wed, 18 Jul 2018 12:59:38 +0900 (KST)
Message-ID: <20180718.125938.2271502580775162784.davem@davemloft.net>
References: <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
        <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
        <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        nikita.leshchenko@oracle.com, roopa@cumulusnetworks.com,
        stephen@networkplumber.org, idosch@mellanox.com, jiri@mellanox.com,
        saeedm@mellanox.com, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: dsahern@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Tue, 17 Jul 2018 13:02:18 -0600

> I understand the concern about global resource and limits: as it stands
> you have to increase the limits in init_net to the max expected and hope
> for the best. With per namespace limits you can lower the limits of each
> namespace better control the total impact on the total memory used.
> Perhaps the defaults for namespaces after init_net could have really low
> defaults (e.g., 16 / 32 / 64 for gc_thresh 1/2/3) requiring admin
> intervention.

How does this work when a namespace creates another namespace?

Changing the defaults for non-init_net namespaces could work, but that
could be a surprise to some people.
