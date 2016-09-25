From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v5] netfilter: seqadj: Fix the wrong ack adjust for
 the RST packet without ack
Date: Sun, 25 Sep 2016 13:31:53 +0200
Message-ID: <20160925113153.GA8331@salvia>
References: <1474527233-21988-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474527233-21988-1-git-send-email-fgao@ikuai8.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 22, 2016 at 02:53:53PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> It is valid that the TCP RST packet which does not set ack flag, and bytes
> of ack number are zero. But current seqadj codes would adjust the "0" ack
> to invalid ack number. Actually seqadj need to check the ack flag before
> adjust it for these RST packets.

Applied, thanks.
