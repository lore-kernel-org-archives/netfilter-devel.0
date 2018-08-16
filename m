From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: manual merge of the net-next tree with the netfilter
 tree
Date: Thu, 16 Aug 2018 02:08:51 +0200
Message-ID: <20180816000851.if2neqxzbjlsd45n@salvia>
References: <20180807124932.73422224@canb.auug.org.au>
 <20180816094723.07452406@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>, Julian Anastasov <ja@ssi.bg>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180816094723.07452406@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Aug 16, 2018 at 09:47:23AM +1000, Stephen Rothwell wrote:
> On Tue, 7 Aug 2018 12:49:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
[...]
> This is now a conflict between Linus' tree and the netfilter tree.

Will rebase nf.git here, so next pull request already deals with this
here to make it easier for upstream maintainers.

@Matteo, let me know if this is a problem in your case, you may have
references to the original commits in your backport queue probably.

Thanks for the heads up and sorry for the inconvenience.
