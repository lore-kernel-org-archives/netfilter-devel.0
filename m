From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC -next v0 1/3] bpf: modular maps
Date: Wed, 28 Nov 2018 20:19:50 -0800
Message-ID: <20181129041948.pepdcksplt6xppk3@ast-mbp>
References: <20181125180919.13996-1-aconole@bytheb.org>
 <20181125180919.13996-2-aconole@bytheb.org>
 <20181127020608.4vucwmhrtu2cxrwu@ast-mbp.dhcp.thefacebook.com>
 <f7tftvmd2ey.fsf@dhcp-25.97.bos.redhat.com>
 <20181128051001.wcsgqx3d6c2aszp6@ast-mbp.dhcp.thefacebook.com>
 <f7to9a99gsh.fsf@dhcp-25.97.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Gospodarek <andy@greyhouse.net>,
        Rony Efraim <ronye@mellanox.com>,
        Simon Horman <horms@verge.net.au>,
        Marcelo Leitner <marcelo.leitner@gmail.com>
To: Aaron Conole <aconole@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f7to9a99gsh.fsf@dhcp-25.97.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 28, 2018 at 01:51:42PM -0500, Aaron Conole wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Tue, Nov 27, 2018 at 09:24:05AM -0500, Aaron Conole wrote:
> >> 
> >>   1. Introduce flowmap again, this time, basically having it close to a
> >>      copy of the hashmap.  Introduce a few function calls that allow an
> >>      external module to easily manipulate all maps of that type to insert
> >>      / remove / update entries.  This makes it similar to, for example,
> >>      devmap.
> >
> > what is a flowmap?
> > How is this flowmap different from existing hash, lpm and lru maps?
> 
> The biggest difference is how relationship works.  Normal map would
> have single key and single value.  Flow map needs to have two keys
> "single-value," because there are two sets of flow tuples to track
> (forward and reverse direction).  That means that when updating the k-v
> pairs, we need to ensure that the data is always consistent and up to
> date.  Probably we could do that with the existing maps if we had some
> kind of allocation mechanism, too (so, keep a pointer to data from two
> keys - not sure if there's a way to do that in ebpf)?

just swap the src/dst ips inside bpf program depending on direction
and use the same hash map.
That's what xdp/bpf users already do pretty successfully.
bpf hash map is already offloaded into hw too.

> forward direction addresses could be different from reverse direction so
> just swapping addresses / ports will not match).

That makes no sense to me. What would be an example of such flow?
Certainly not a tcp flow.

> That lets us use xdp as a fast forwarding path for
> connections, getting all of the advantage of helper modules to do the
> control / parsing, and all the advantage of xdp for packet movement.

>From 10k feet view it sounds correct, but details make no sense.
You're saying doing nat in the stack, but that _is_ the packet movement
where you wanted to use xdp.
