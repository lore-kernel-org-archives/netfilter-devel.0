From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [RFC -next v0 1/3] bpf: modular maps
Date: Fri, 30 Nov 2018 08:49:17 -0500
Message-ID: <f7twoou65gi.fsf@dhcp-25.97.bos.redhat.com>
References: <20181125180919.13996-1-aconole@bytheb.org>
        <20181125180919.13996-2-aconole@bytheb.org>
        <20181127020608.4vucwmhrtu2cxrwu@ast-mbp.dhcp.thefacebook.com>
        <f7tftvmd2ey.fsf@dhcp-25.97.bos.redhat.com>
        <20181128051001.wcsgqx3d6c2aszp6@ast-mbp.dhcp.thefacebook.com>
        <f7to9a99gsh.fsf@dhcp-25.97.bos.redhat.com>
        <20181129041948.pepdcksplt6xppk3@ast-mbp>
Mime-Version: 1.0
Content-Type: text/plain
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
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181129041948.pepdcksplt6xppk3@ast-mbp> (Alexei Starovoitov's
        message of "Wed, 28 Nov 2018 20:19:50 -0800")
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Nov 28, 2018 at 01:51:42PM -0500, Aaron Conole wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> 
>> > On Tue, Nov 27, 2018 at 09:24:05AM -0500, Aaron Conole wrote:
>> >> 
>> >>   1. Introduce flowmap again, this time, basically having it close to a
>> >>      copy of the hashmap.  Introduce a few function calls that allow an
>> >>      external module to easily manipulate all maps of that type to insert
>> >>      / remove / update entries.  This makes it similar to, for example,
>> >>      devmap.
>> >
>> > what is a flowmap?
>> > How is this flowmap different from existing hash, lpm and lru maps?
>> 
>> The biggest difference is how relationship works.  Normal map would
>> have single key and single value.  Flow map needs to have two keys
>> "single-value," because there are two sets of flow tuples to track
>> (forward and reverse direction).  That means that when updating the k-v
>> pairs, we need to ensure that the data is always consistent and up to
>> date.  Probably we could do that with the existing maps if we had some
>> kind of allocation mechanism, too (so, keep a pointer to data from two
>> keys - not sure if there's a way to do that in ebpf)?
>
> just swap the src/dst ips inside bpf program depending on direction
> and use the same hash map.

That won't work.  I'll explain below.

> That's what xdp/bpf users already do pretty successfully.
> bpf hash map is already offloaded into hw too.

While this is one reason to use hash map, I don't think we should use
this as a reason to exclude development of a data type that may work
better.  After all, if we can do better then we should.

>> forward direction addresses could be different from reverse direction so
>> just swapping addresses / ports will not match).
>
> That makes no sense to me. What would be an example of such flow?
> Certainly not a tcp flow.

Maybe it's poorly worded on my part.  Think about this scenario (ipv4, tcp):

Interfaces A(internet), B(lan)

When XDP program receives a packet from B, it will have a tuple like:

source=B-subnet:B-port  dest=inet-addr:inet-port

When XDP program receives a packet from A, it will have a tuple like:

source=inet-addr:inet-port  dest=gw-addr:gw-port

The only data in common there is inet-addr:inet-port, and that will
likely be shared among too many connections to be a valid key.

I don't know how to figure out from A the same connetion that
corresponds to B.  A really simple static map works, *except*, when
something causes either side of the connection to become invalid, I
can't mark the other side.  For instance, even if I have some static
mapping, I might not be able to infer the correct B-side tuple from the
A-side tuple to do the teardown.

I might too naive to see the right approach though - maybe I'm
over-complicating something?

>> That lets us use xdp as a fast forwarding path for
>> connections, getting all of the advantage of helper modules to do the
>> control / parsing, and all the advantage of xdp for packet movement.
>
> From 10k feet view it sounds correct, but details make no sense.
> You're saying doing nat in the stack, but that _is_ the packet movement
> where you wanted to use xdp.

The thing I want to use the stack for are things that will always be
slow anyway, or require massive system input to do correctly.  Here are
some examples:

1. Port / address reservation.  If I want to do NAT, I need to reserve
   ports and addresses correctly.  That requires knowing the interface
   addresses, and which addresses are currently allocated.  The stack
   knows this already, let it do these allocations then.  Then when
   packets arrive for the connection that the stack set up, just forward
   via XDP.

2. Helpers.  Parsing an in-flight stream is always going to be slow.
   Let the stack do that.  But when it sets up an expectation, then use
   that information to forward that via XDP.

So I would use the stack for the initial handshakes.  Once the handshake
is complete, and we know where the packet is destined to go, all that
data is shoved into a map that the XDP program can access, and we
do the data forwarding.

Hope it helps.
