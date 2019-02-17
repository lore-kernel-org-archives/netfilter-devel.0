From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter/ipvs: Fix unused variable warning
Date: Sun, 17 Feb 2019 13:51:56 +0100
Message-ID: <20190217125156.ywp35hqlflafns6e@salvia>
References: <20190216223358.30711-1-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Julian Anastasov <ja@ssi.bg>, Li Shuang <shuali@redhat.com>,
        netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190216223358.30711-1-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Feb 16, 2019 at 11:33:58PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Move the local variable 'ret' into the IP_VS_IPV6 ifdef so that the
> unused variable warning doesn't fire for randconfig builds with
> CONFIG_IP_VS_IPV6 disabled.

Thanks! We already have a patch for this, will pass it to David asap.

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=c93a49b9769e435990c82297aa0baa31e1538790
