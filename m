From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: [Bridge] [PATCH net-next] bridge: ebtables: Avoid resetting
 limit rule state
Date: Mon, 4 Dec 2017 06:20:06 +0100
Message-ID: <20171204052006.GF3307@otheros>
References: <20171125074418.16537-1-linus.luessing@c0d3.blue>
 <20171127233008.GA1418@salvia>
 <20171204045335.GE3307@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171204045335.GE3307@otheros>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Dec 04, 2017 at 05:53:35AM +0100, Linus Lüssing wrote:
> And so, no I do not have this patch. I looked at it now, but it
> does not seem to have any relation with .matchinfo, does it?

Relation between .usersize and .checkentry I ment, not
.usersize and .matchinfo.
