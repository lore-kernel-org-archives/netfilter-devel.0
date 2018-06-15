From: Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 13:12:28 -0700
Message-ID: <CALx6S36fm87UjWvKy-c8yOMTtAJgNt64BYZW5Mpw3SM=dJPQ0g@mail.gmail.com>
References: <20180614141947.3580-1-pablo@netfilter.org> <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
 <20180614.165834.338565136334574983.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614.165834.338565136334574983.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 4:58 PM, David Miller <davem@davemloft.net> wrote:
> From: Tom Herbert <tom@herbertland.com>
> Date: Thu, 14 Jun 2018 13:52:03 -0700
>
>> IIRC, there was a similar proposal a while back that want to bundle
>> packets of the same flow together (without doing GRO) so that they
>> could be processed by various functions by looking at just one
>> representative packet in the group. The concept had some promise, but
>> in the end it created quite a bit of complexity since at some point
>> the packet bundle needed to be undone to go back to processing the
>> individual packets.
>
> You're probably talking about Edward Cree's SKB list stuff, and as
> per his presenation at netconf 2 weeks ago he plans to revitalize
> it given how Spectre et al. gives cause to reevaluate all bulking
> techniques.nearly

The use case for that will be an interesting question. GSO/GRO solves
the problem for TCP and this extends to nearly all cases where TCP is
in an encapsulated packet. Super efficient forwarding can be done in
XDP/BPF (without needing overhead of GSO/GRO). That pretty much leaves
UDP as non-encapsulation end protocol, which I guess these days pretty
much means QUIC :-) I am still interested to see if we can implement
GSO/GRO for QUIC (via a generic GSO/GRO BPF function so we don't
hardcode any QUIC protocol or other application protocols in kernel).

Tom
