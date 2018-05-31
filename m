From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] netfilter: nf_tables: check msg_type before
 nft_trans_set(trans)
Date: Thu, 31 May 2018 21:07:31 +0200
Message-ID: <20180531190731.rrwayqgnnnd2fasn@breakpoint.cc>
References: <1527785613-32005-1-git-send-email-alexey.kodanev@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>
To: Alexey Kodanev <alexey.kodanev@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527785613-32005-1-git-send-email-alexey.kodanev@oracle.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Kodanev <alexey.kodanev@oracle.com> wrote:
> The patch moves the "trans->msg_type == NFT_MSG_NEWSET" check before
> using nft_trans_set(trans). Otherwise we can get out of bounds read.

Indeed, thanks for fixining this.

Acked-by: Florian Westphal <fw@strlen.de>
