From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [RFC -next v0 1/3] bpf: modular maps
Date: Mon, 10 Dec 2018 11:49:47 -0500
Message-ID: <f7tefap5ntg.fsf@dhcp-25.97.bos.redhat.com>
References: <20181125180919.13996-1-aconole@bytheb.org>
        <20181125180919.13996-2-aconole@bytheb.org>
        <20181127020608.4vucwmhrtu2cxrwu@ast-mbp.dhcp.thefacebook.com>
        <f7tftvmd2ey.fsf@dhcp-25.97.bos.redhat.com>
        <20181128051001.wcsgqx3d6c2aszp6@ast-mbp.dhcp.thefacebook.com>
        <f7to9a99gsh.fsf@dhcp-25.97.bos.redhat.com>
        <20181129041948.pepdcksplt6xppk3@ast-mbp>
        <f7twoou65gi.fsf@dhcp-25.97.bos.redhat.com>
        <20181205024928.57xcrgspllcr7umo@ast-mbp.dhcp.thefacebook.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205024928.57xcrgspllcr7umo@ast-mbp.dhcp.thefacebook.com>
        (Alexei Starovoitov's message of "Tue, 4 Dec 2018 18:49:30 -0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Nov 30, 2018 at 08:49:17AM -0500, Aaron Conole wrote:
>> 
>> While this is one reason to use hash map, I don't think we should use
>> this as a reason to exclude development of a data type that may work
>> better.  After all, if we can do better then we should.
>
> I'm all for improving existing hash map or implementing new data types.
> Like classifier map == same as wild-card match map == ACL map.
> The one that OVS folks could use and other folks wanted for long time.
>
> But I don't want bpf to become a collection of single purpose solutions.
> Like mega-flow style OVS map.
> That one does linear number of lookups applying mask at a time.
>
> It sounds to me that you're proposing "NAT-as-bpf-helper"
> or "NAT-as-bpf-map" type of solution.

Maybe that's what this particular iteration is.  But I'm open to a
different implementation.  My requirements aren't fixed to a specific
map type.

> That falls into single purpose solution category.
> I'd rather see generic connection tracking building block.
> The one that works out of skb and out of XDP layer.
> Existing stack-queue-map can already be used to allocate integers
> out of specified range. It can be used to implement port allocation for NAT.
> If generic stack-queue-map is not enough, let's improve it.

I don't understand this.  You say you want something out of skb and out
of xdp layer, but then advocate an ebpf approach (that would only be
useful from xdp).  Plus already some specialized mechanism exists for
FIB.  Not sure why this conntrack assist would be rejected as too
specialized?

I was thinking to re-use existing conntrack framework, and make the
metadata available from ebpf context.  That can be used even out of xdp
layer (for instance, maybe some tracing program, or other accounting /
auditing tool like a HIDS).

Anyway, as I wrote, there are other approaches.  But maybe instead of a
flowmap, an mkmap would make sense (this is a multi-key map, that allows
a single value to be reached via multiple keys).  I also wrote some
other approaches I was thinking in an earlier mail.  Maybe one of those
is better direction?

>> >> forward direction addresses could be different from reverse direction so
>> >> just swapping addresses / ports will not match).
>> >
>> > That makes no sense to me. What would be an example of such flow?
>> > Certainly not a tcp flow.
>> 
>> Maybe it's poorly worded on my part.  Think about this scenario (ipv4, tcp):
>> 
>> Interfaces A(internet), B(lan)
>> 
>> When XDP program receives a packet from B, it will have a tuple like:
>> 
>> source=B-subnet:B-port  dest=inet-addr:inet-port
>> 
>> When XDP program receives a packet from A, it will have a tuple like:
>> 
>> source=inet-addr:inet-port  dest=gw-addr:gw-port
>
> first of all there are two netdevs.
> one XDP program can attach to multiple netdevs, but in this
> case we're dealing with two indepedent tcp flows.
>
>> The only data in common there is inet-addr:inet-port, and that will
>> likely be shared among too many connections to be a valid key.
>
> two independent tcp flows don't make a 'connection'.
> That definition of connection is only meaningful in the context
> of the particular problem you're trying to solve and
> confuses me quite a bit.

I don't understand this.

They aren't independent.  We need to properly account the packets, and
need to apply policy decisions to either side.  Just because the tuples
are asymmetric, the connection *is* the same.  If you treat them
separately, then you lose the ability for accounting them properly.
Something needs to make the association.

>> I don't know how to figure out from A the same connetion that
>> corresponds to B.  A really simple static map works, *except*, when
>> something causes either side of the connection to become invalid, I
>> can't mark the other side.  For instance, even if I have some static
>> mapping, I might not be able to infer the correct B-side tuple from the
>> A-side tuple to do the teardown.
>
> I don't think I got enough information from the above description to
> understand why two tcp flows (same as two tcp connections) will
> form single 'connection' in your definition of connection.

They aren't two connections.  Maybe there's something I'm missing.

>> 1. Port / address reservation.  If I want to do NAT, I need to reserve
>>    ports and addresses correctly.  That requires knowing the interface
>>    addresses, and which addresses are currently allocated.  The stack
>>    knows this already, let it do these allocations then.  Then when
>>    packets arrive for the connection that the stack set up, just forward
>>    via XDP.
>
> I beg to disagree. For NAT use case the stack has nothing to do with
> port allocation for NATing. It's all within NAT framework
> (whichever way it's implemented).
> The stack cares about sockets and ports that are open on the host
> to be consumed by the host.
> NAT function is independent of that.

It's related.  If host has a particular port open, NAT can't reuse it if
NATing from a host IP.
So the NAT port allocation *must* take into account host ports.

>> 2. Helpers.  Parsing an in-flight stream is always going to be slow.
>>    Let the stack do that.  But when it sets up an expectation, then use
>>    that information to forward that via XDP.
>
> XDP parses packets way faster than the stack, since XDP deals with linear
> buffers whereas stack has to do pskb_may_pull at every step.

Sure.

> The stack can be optimized further, but assuming that packet parsing
> by the stack is faster than XDP and making techincal decisions based
> on that just doesn't seem like the right approach to take.

Agreed that packet parsing can be faster in XDP.  But my point is,
packet parsing is *slow* no matter what.  And the DPI required to
implement helpers is complex and slow.  The instant you need to parse
H.323 or some kind of SIP logic to implement conntrack helper you will
run out of instructions and tailcall iterations in eBPF.  Even simple FTP
parsing might not be 'good enough' from a throughput standpoint.  The
idea here is for control kinds of connections to traverse the stack
(since throughput isn't gating factor there), and the data connections
(which need maximum throughput) can just be switched via the xdp
mechanism.
