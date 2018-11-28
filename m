From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC -next v0 1/3] bpf: modular maps
Date: Tue, 27 Nov 2018 21:10:03 -0800
Message-ID: <20181128051001.wcsgqx3d6c2aszp6@ast-mbp.dhcp.thefacebook.com>
References: <20181125180919.13996-1-aconole@bytheb.org>
 <20181125180919.13996-2-aconole@bytheb.org>
 <20181127020608.4vucwmhrtu2cxrwu@ast-mbp.dhcp.thefacebook.com>
 <f7tftvmd2ey.fsf@dhcp-25.97.bos.redhat.com>
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
To: Aaron Conole <aconole@bytheb.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f7tftvmd2ey.fsf@dhcp-25.97.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 27, 2018 at 09:24:05AM -0500, Aaron Conole wrote:
> 
>   1. Introduce flowmap again, this time, basically having it close to a
>      copy of the hashmap.  Introduce a few function calls that allow an
>      external module to easily manipulate all maps of that type to insert
>      / remove / update entries.  This makes it similar to, for example,
>      devmap.

what is a flowmap?
How is this flowmap different from existing hash, lpm and lru maps?
'close to a copy of hashmap'... why hashmap is not enough for your purpose?
