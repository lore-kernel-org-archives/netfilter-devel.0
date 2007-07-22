From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [NETFILTER -stable]: nf_conntrack: don't track locally
	generated special ICMP error
Date: Mon, 23 Jul 2007 00:48:05 +0200
Message-ID: <20070722224805.GI26212@stusta.de>
References: <469CDF56.80600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	"David S. Miller" <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <469CDF56.80600@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 17, 2007 at 05:25:10PM +0200, Patrick McHardy wrote:
> Attached are two patches (stable.diff, applies to stable-2.6.21 and
> stable-2.6.22 and 2.6.16.diff for stable-2.6.16) fixing incorrect
> conntrack association of ICMP errors generated in response to INVALID
> packets, causing incorrect address translation in combination with NAT.
> 
> Please apply, thanks.

Thanks, applied to 2.6.16.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
