From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Thu, 14 Jun 2018 11:50:49 -0400
Message-ID: <CAF=yD-+fJ_isaGtfLFVgMQ4_7K-v7b+Kyo6iOB-5kUbbPJXT7Q@mail.gmail.com>
References: <20180614141947.3580-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        steffen.klassert@secunet.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> This patchset supports both layer 3 IPv4 and IPv6, and layer 4 TCP and
> UDP protocols. This fastpath also integrates with the IPSec
> infrastructure and the ESP protocol.
>
> We have collected performance numbers:
>
>         TCP TSO         TCP Fast Forward
>         32.5 Gbps       35.6 Gbps
>
>         UDP             UDP Fast Forward
>         17.6 Gbps       35.6 Gbps
>
>         ESP             ESP Fast Forward
>         6 Gbps          7.5 Gbps
>
> For UDP, this is doubling performance, and we almost achieve line rate
> with one single CPU using the Intel i40e NIC. We got similar numbers
> with the Mellanox ConnectX-4. For TCP, this is slightly improving things
> even if TSO is being defeated given that we need to segment the packet
> chain in software.

The difference between TCP and UDP stems from lack of GRO for UDP. We
recently added UDP GSO to allow for batch traversal of the UDP stack on
transmission. Adding a UDP GRO handler can probably extend batching to
the forwarding path in a similar way without the need for a new infrastructure.
