From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Tue, 24 Jul 2018 10:14:05 -0700 (PDT)
Message-ID: <20180724.101405.797730329231867648.davem@davemloft.net>
References: <28c30574-391c-b4bd-c337-51d3040d901a@gmail.com>
        <CAM_iQpW4-JkZY7jXx0Q1b907hQ85UOL1eXv2YHwSukb5L=apUg@mail.gmail.com>
        <5021d874-8e99-6eba-f24b-4257c62d4457@gmail.com>
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
In-Reply-To: <5021d874-8e99-6eba-f24b-4257c62d4457@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Tue, 24 Jul 2018 09:14:01 -0600

> I get the impression there is no longer a strong resistance against
> moving the tables to per namespace, but deciding what is the right
> approach to handle backwards compatibility. Correct? Changing the
> accounting is inevitably going to be noticeable to some use case(s), but
> with sysctl settings it is a simple runtime update once the user knows
> to make the change.
> 
> neighbor entries round up to 512 byte allocations, so with the current
> gc_thresh defaults (128/512/1024) 512k can be consumed. Using those
> limits per namespace seems high which is why I suggested a per-namespace
> default of (16/32/64) which amounts to 32k per namespace limit by
> default. Open to other suggestions as well.

No objection from me about going to per-ns neigh tables.

About the defaults, I wonder if we can scale them to the amount of
memory given to the ns or something like that?  I bet this will better
match the intended use of the ns.
