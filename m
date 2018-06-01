From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: nf_tables: check msg_type before
 nft_trans_set(trans)
Date: Fri, 1 Jun 2018 10:14:11 +0200
Message-ID: <20180601081411.sk4py3rkduckmiyg@salvia>
References: <1527785613-32005-1-git-send-email-alexey.kodanev@oracle.com>
 <20180531190731.rrwayqgnnnd2fasn@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Kodanev <alexey.kodanev@oracle.com>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531190731.rrwayqgnnnd2fasn@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 31, 2018 at 09:07:31PM +0200, Florian Westphal wrote:
> Alexey Kodanev <alexey.kodanev@oracle.com> wrote:
> > The patch moves the "trans->msg_type == NFT_MSG_NEWSET" check before
> > using nft_trans_set(trans). Otherwise we can get out of bounds read.
> 
> Indeed, thanks for fixining this.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Also applied to nf.git, thanks!
