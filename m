From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] [net-next] netfilter: add ifdef around
 ctnetlink_proto_size
Date: Mon, 13 Nov 2017 13:43:14 +0100
Message-ID: <20171113124314.GA6695@salvia>
References: <20171107141214.3312784-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Liping Zhang <zlpnobody@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107141214.3312784-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 07, 2017 at 03:11:51PM +0100, Arnd Bergmann wrote:
> This function is no longer marked 'inline', so we now get a warning
> when it is unused:
> 
> net/netfilter/nf_conntrack_netlink.c:536:15: error: 'ctnetlink_proto_size' defined but not used [-Werror=unused-function]
> 
> We could mark it inline again, mark it __maybe_unused, or add an #ifdef
> around the definition. I'm picking the third approach here since that
> seems to be what the rest of the file has.

Applied, thanks Arnd.
