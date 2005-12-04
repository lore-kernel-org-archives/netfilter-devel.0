From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t
Date: Sun, 04 Dec 2005 12:20:53 -0800 (PST)
Message-ID: <20051204.122053.117831054.davem@davemloft.net>
References: <439313B2.50601@trash.net>
	<20051204.114813.59310147.davem@davemloft.net>
	<43934B40.60309@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43934B40.60309@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 04 Dec 2005 21:02:08 +0100

> Some ugly workarounds might be possible, but considering that
> ctnetlink is new and how much problems it still has, it shouldn't be
> a big problem to do this right and break compatibility.

Yes, this is how I see it too.
