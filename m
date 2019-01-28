From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft_counter: remove wrong __percpu of
 nft_counter_resest()'s arg
Date: Mon, 28 Jan 2019 11:20:22 +0100
Message-ID: <20190128102022.mrnh2j6orgnrdfyp@salvia>
References: <20190119215024.90174-1-luc.vanoostenryck@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190119215024.90174-1-luc.vanoostenryck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jan 19, 2019 at 10:50:24PM +0100, Luc Van Oostenryck wrote:
> nft_counter_rest() has its first argument declared as
> 	struct nft_counter_percpu_priv __percpu *priv
> but this structure is not percpu (it only countains
> a member 'counter' which is, correctly, a pointer to a
> percpu struct nft_counter).
> 
> So, remove the '__percpu' from the argument's declaration.

Applied, thanks.
