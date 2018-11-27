From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [RFC -next v0 1/3] bpf: modular maps
Date: Tue, 27 Nov 2018 09:24:05 -0500
Message-ID: <f7tftvmd2ey.fsf@dhcp-25.97.bos.redhat.com>
References: <20181125180919.13996-1-aconole@bytheb.org>
        <20181125180919.13996-2-aconole@bytheb.org>
        <20181127020608.4vucwmhrtu2cxrwu@ast-mbp.dhcp.thefacebook.com>
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
In-Reply-To: <20181127020608.4vucwmhrtu2cxrwu@ast-mbp.dhcp.thefacebook.com>
        (Alexei Starovoitov's message of "Mon, 26 Nov 2018 18:06:09 -0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sun, Nov 25, 2018 at 01:09:17PM -0500, Aaron Conole wrote:
>> This commit allows for map operations to be loaded by an lkm, rather than
>> needing to be baked into the kernel at compile time.
>
> Nack.
> Please see Documentation/bpf/bpf_design_QA.rst

Thanks for the review, Alexei!  I hadn't been aware of this doc, so it's
good to read through it.

I see that the following is there:

   Q: New functionality via kernel modules?
   ----------------------------------------
   Q: Can BPF functionality such as new program or map types, new
   helpers, etc be added out of kernel module code?

   A: NO.

So, I think that means that even changing the helpers would be of no
value (since it would only be useful in the event that the kernel were
compiled with netfilter linked in, rather than as a module - and I doubt
there's any place where that would be true).

BUT, as I wrote in my cover I have some alternative approaches that I've
thought about, and I'm listing here.  Can you let me know if any would
be acceptable?  If none are, is there an alternative approach you would
support?

  1. Introduce flowmap again, this time, basically having it close to a
     copy of the hashmap.  Introduce a few function calls that allow an
     external module to easily manipulate all maps of that type to insert
     / remove / update entries.  This makes it similar to, for example,
     devmap.

  2. Introduce a way to share maps between modules.  IE:
     something like bpf_helper_expose_map(map_id, module_name).  Then have
     netfilter and eBPF share access to the hashmap.  Netfilter and the
     ebpf program will need to agree on the key and value size, and will
     push data in/out.

  3. Introduce an xdp/ebpf hook in the flowmap.
     IE: nft add flowmap xx { .program=foo.o }
     Then that will be called with a context, and can update a shared map
     with userspace.  I haven't though out all the logistics on how to do
     this, but it would put the onus of sharing the information on the
     bpf program writer.

What do you think?
