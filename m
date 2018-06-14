From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Thu, 14 Jun 2018 10:18:31 -0700 (PDT)
Message-ID: <20180614.101831.465275975690050595.davem@davemloft.net>
References: <20180614141947.3580-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 14 Jun 2018 16:19:34 +0200

> This patchset proposes a new fast forwarding path infrastructure
> that combines the GRO/GSO and the flowtable infrastructures. The
> idea is to add a hook at the GRO layer that is invoked before the
> standard GRO protocol offloads. This allows us to build custom
> packet chains that we can quickly pass in one go to the neighbour
> layer to define fast forwarding path for flows.

We have full, complete, customizability of the packet path via XDP
and eBPF.

XDP and eBPF supports everything necessary to accomplish that,
there are implementations of forwarding implementations in
the tree and elsewhere.

And most importantly, XDP and eBPF are optimized in drivers and
offloaded to hardware.

There really is no need for something like what you are proposing.
