From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Add bridged IPv6 packet filtering
Date: Wed, 1 Sep 2004 15:38:12 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040901153812.31a07044.davem@davemloft.net>
References: <200409012234.26310.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200409012234.26310.bdschuym@pandora.be>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 1 Sep 2004 22:34:26 +0200
Bart De Schuymer <bdschuym@pandora.be> wrote:

> From reading Yasuyuki's reply and the specific code, the IPv6 checks
> before giving a bridged packet to ip6tables should now be accurate.

Looks fine, patch applied.

Thanks Bart.
