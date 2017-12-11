From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 27/45] net: remove duplicate includes
Date: Mon, 11 Dec 2017 20:04:55 +0100
Message-ID: <20171211190455.GA12285@salvia>
References: <1513010386-3394-1-git-send-email-pravin.shedge4linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, f.fainelli@gmail.com,
        kadlec@blackhole.kfki.hu, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mingo@kernel.org,
        rmk+kernel@armlinux.org.uk, linux-kernel@vger.kernel.org
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513010386-3394-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Dec 11, 2017 at 10:09:46PM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

For the Netfilter chunk.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
