From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Fri, 16 Feb 2018 15:57:27 +0100
Message-ID: <20180216145727.GC32618@breakpoint.cc>
References: <20180216134023.15536-1-daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, alexei.starovoitov@gmail.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180216134023.15536-1-daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> wrote:
> This is a very rough and early proof of concept that implements bpfilter.

[..]

> Also, as a benefit from such design, we get BPF JIT compilation on x86_64,
> arm64, ppc64, sparc64, mips64, s390x and arm32, but also rule offloading
> into HW for free for Netronome NFP SmartNICs that are already capable of
> offloading BPF since we can reuse all existing BPF infrastructure as the
> back end. The user space iptables binary issuing rule addition or dumps was
> left as-is, thus at some point any binaries against iptables uapi kernel
> interface could transparently be supported in such manner in long term.
>
> As rule translation can potentially become very complex, this is performed
> entirely in user space. In order to ease deployment, request_module() code
> is extended to allow user mode helpers to be invoked. Idea is that user mode
> helpers are built as part of the kernel build and installed as traditional
> kernel modules with .ko file extension into distro specified location,
> such that from a distribution point of view, they are no different than
> regular kernel modules. Thus, allow request_module() logic to load such
> user mode helper (umh) binaries via:
> 
>   request_module("foo") ->
>     call_umh("modprobe foo") ->
>       sys_finit_module(FD of /lib/modules/.../foo.ko) ->
>         call_umh(struct file)
>
> Such approach enables kernel to delegate functionality traditionally done
> by kernel modules into user space processes (either root or !root) and
> reduces security attack surface of such new code, meaning in case of
> potential bugs only the umh would crash but not the kernel. Another
> advantage coming with that would be that bpfilter.ko can be debugged and
> tested out of user space as well (e.g. opening the possibility to run
> all clang sanitizers, fuzzers or test suites for checking translation).

Several questions spinning at the moment, I will probably come up with
more:
1. Does this still attach the binary blob to the 'normal' iptables
   hooks?
2. If yes, do you see issues wrt. 'iptables' and 'bpfilter' attached
programs being different in nature (e.g. changed by different entities)?
3. What happens if the rule can't be translated (yet?)
4. Do you plan to reimplement connection tracking in userspace?
If no, how will the bpf program interact with it?
[ same question applies to ipv6 exthdr traversal, ip defragmentation
and the like ].

I will probably have a quadrillion of followup questions, sorry :-/

> Also, such architecture makes the kernel/user boundary very precise,
> meaning requests can be handled and BPF translated in control plane part
> in user space with its own user memory etc, while minimal data plane
> bits are in kernel. It would also allow to remove old xtables modules
> at some point from the kernel while keeping functionality in place.

This is what we tried with nftables :-/
