From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Fri, 16 Feb 2018 17:53:33 +0100
Message-ID: <60671f99-afe5-f7b0-ae26-5cc9ca6e0f10@iogearbox.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, alexei.starovoitov@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180216145727.GC32618@breakpoint.cc>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Florian,

thanks for your feedback! More inline:

On 02/16/2018 03:57 PM, Florian Westphal wrote:
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> This is a very rough and early proof of concept that implements bpfilter.
> 
> [..]
> 
>> Also, as a benefit from such design, we get BPF JIT compilation on x86_64,
>> arm64, ppc64, sparc64, mips64, s390x and arm32, but also rule offloading
>> into HW for free for Netronome NFP SmartNICs that are already capable of
>> offloading BPF since we can reuse all existing BPF infrastructure as the
>> back end. The user space iptables binary issuing rule addition or dumps was
>> left as-is, thus at some point any binaries against iptables uapi kernel
>> interface could transparently be supported in such manner in long term.
>>
>> As rule translation can potentially become very complex, this is performed
>> entirely in user space. In order to ease deployment, request_module() code
>> is extended to allow user mode helpers to be invoked. Idea is that user mode
>> helpers are built as part of the kernel build and installed as traditional
>> kernel modules with .ko file extension into distro specified location,
>> such that from a distribution point of view, they are no different than
>> regular kernel modules. Thus, allow request_module() logic to load such
>> user mode helper (umh) binaries via:
>>
>>   request_module("foo") ->
>>     call_umh("modprobe foo") ->
>>       sys_finit_module(FD of /lib/modules/.../foo.ko) ->
>>         call_umh(struct file)
>>
>> Such approach enables kernel to delegate functionality traditionally done
>> by kernel modules into user space processes (either root or !root) and
>> reduces security attack surface of such new code, meaning in case of
>> potential bugs only the umh would crash but not the kernel. Another
>> advantage coming with that would be that bpfilter.ko can be debugged and
>> tested out of user space as well (e.g. opening the possibility to run
>> all clang sanitizers, fuzzers or test suites for checking translation).
> 
> Several questions spinning at the moment, I will probably come up with
> more:

Sure, no problem at all. It's an early RFC, so purpose is to get a
discussion going on such potential approach.

> 1. Does this still attach the binary blob to the 'normal' iptables
>    hooks?

Yeah, so thought would be to keep the user land tooling functional as
is w/o having to recompile binaries, thus this would also need to attach
for the existing hooks in order to keep semantics working. As a benefit
in addition we can also reuse all the rest of the infrastructure to utilize
things like XDP for iptables in the background, there is definitely
flexibility on this side thus users could eventually benefit from this
transparently and don't need to know that 'bpfilter' exists and is
translating in the background. I realize taking this path is a long term
undertake that we would need to tackle as a community, not just one or
two individuals when we decide to go for this direction.

> 2. If yes, do you see issues wrt. 'iptables' and 'bpfilter' attached
> programs being different in nature (e.g. changed by different entities)?

There could certainly be multiple options, e.g. a fall-through with state
transfer once a request cannot be handled yet or a sysctl with iptables
being the default handler and an option to switch to bpfilter for letting
it handle requests for that time being.

> 3. What happens if the rule can't be translated (yet?)

(See above.)

> 4. Do you plan to reimplement connection tracking in userspace?

One option could be to have a generic, skb-less connection tracker in kernel
that can be reused from the various hooks it would need to handle, potentially
that would also be able to get offloaded into HW as another benefit coming
out from that.

> If no, how will the bpf program interact with it?
> [ same question applies to ipv6 exthdr traversal, ip defragmentation
> and the like ].

The v6 exthdr traversal could be realized natively via BPF which should
make the parsing more robust at the same time than having it somewhere
inside a helper in kernel directly; bounded loops in BPF would help as
well on that front, similarly for defrag this could be handled by the prog
although here we would need additional infra to queue the packets and then
recirculate.

> I will probably have a quadrillion of followup questions, sorry :-/

Definitely, please do!

Thanks,
Daniel

>> Also, such architecture makes the kernel/user boundary very precise,
>> meaning requests can be handled and BPF translated in control plane part
>> in user space with its own user memory etc, while minimal data plane
>> bits are in kernel. It would also allow to remove old xtables modules
>> at some point from the kernel while keeping functionality in place.
> 
> This is what we tried with nftables :-/
