From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Thu, 14 Jun 2018 16:58:34 -0700 (PDT)
Message-ID: <20180614.165834.338565136334574983.davem@davemloft.net>
References: <20180614141947.3580-1-pablo@netfilter.org>
        <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com
To: tom@herbertland.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Thu, 14 Jun 2018 13:52:03 -0700

> IIRC, there was a similar proposal a while back that want to bundle
> packets of the same flow together (without doing GRO) so that they
> could be processed by various functions by looking at just one
> representative packet in the group. The concept had some promise, but
> in the end it created quite a bit of complexity since at some point
> the packet bundle needed to be undone to go back to processing the
> individual packets.

You're probably talking about Edward Cree's SKB list stuff, and as
per his presenation at netconf 2 weeks ago he plans to revitalize
it given how Spectre et al. gives cause to reevaluate all bulking
techniques.
