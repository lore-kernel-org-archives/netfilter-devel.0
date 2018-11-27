From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC -next v0 1/3] bpf: modular maps
Date: Mon, 26 Nov 2018 18:06:09 -0800
Message-ID: <20181127020608.4vucwmhrtu2cxrwu@ast-mbp.dhcp.thefacebook.com>
References: <20181125180919.13996-1-aconole@bytheb.org>
 <20181125180919.13996-2-aconole@bytheb.org>
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
        Simon Horman <horms@verge.net>,
        Marcelo Leitner <marcelo.leitner@gmail.com>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181125180919.13996-2-aconole@bytheb.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Nov 25, 2018 at 01:09:17PM -0500, Aaron Conole wrote:
> This commit allows for map operations to be loaded by an lkm, rather than
> needing to be baked into the kernel at compile time.

Nack.
Please see Documentation/bpf/bpf_design_QA.rst
