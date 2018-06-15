From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 08:34:33 +0200
Message-ID: <20180615063433.g4pqrea4f4pymvvs@gauss3.secunet.de>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
 <20180614.165834.338565136334574983.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <tom@herbertland.com>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614.165834.338565136334574983.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 04:58:34PM -0700, David Miller wrote:
> From: Tom Herbert <tom@herbertland.com>
> Date: Thu, 14 Jun 2018 13:52:03 -0700
> 
> > IIRC, there was a similar proposal a while back that want to bundle
> > packets of the same flow together (without doing GRO) so that they
> > could be processed by various functions by looking at just one
> > representative packet in the group. The concept had some promise, but
> > in the end it created quite a bit of complexity since at some point
> > the packet bundle needed to be undone to go back to processing the
> > individual packets.
> 
> You're probably talking about Edward Cree's SKB list stuff, and as
> per his presenation at netconf 2 weeks ago he plans to revitalize
> it given how Spectre et al. gives cause to reevaluate all bulking
> techniques.

Are there patches for the proposal Edward did a while ago,
or was it just a concept?

Maybe we can somehow put things together, I just need some
batching method that works for IPsec and UDP. It does not
need to be exactly the one we proposing here.
