From: Andrew Collins <bsderandrew@gmail.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Tue, 19 Jun 2018 18:56:45 -0600
Message-ID: <CAKTPYJTBQSwNPx=pV1mQpRc6OriEru-1N7-XegUOOiU-xDMQ8A@mail.gmail.com>
References: <20180614141947.3580-1-pablo@netfilter.org> <20180614.101831.465275975690050595.davem@davemloft.net>
 <66634ba7-3d72-644a-9d26-d9644c540619@gmail.com> <20180614.165549.1790121217625223670.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: f.fainelli@gmail.com, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614.165549.1790121217625223670.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 5:55 PM, David Miller <davem@davemloft.net> wrote:
> And guess what?  Then millions of possibilities would have been
> openned up, rather than just this one special case.
>
> So, I ask, please see the larger picture.

+cc netdev/etc

This is perhaps unrelated to the topic at hand, but as someone who's shipped
a bunch of devices over the years using the linux kernel forwarding path and
needs performance but wants to avoid moving to out of tree userspace offload
for all the reasons that you and many others have stated, is the long
term vision that the existing kernel forwarding path will transparently take
advantage of eBPF (ala bpfilter), or that users will write custom/individualized
eBPF forwarding paths for their usecases as necessary?

I (and I suspect many others) will start on the latter anyways, I'm just curious
whether it's desired/expected that such custom fastpath users will eventually
be rolled back into/replaced by a transparent upstream in-kernel equivalent.
