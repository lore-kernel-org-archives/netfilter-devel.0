From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t
Date: Sun, 04 Dec 2005 11:48:13 -0800 (PST)
Message-ID: <20051204.114813.59310147.davem@davemloft.net>
References: <438CDF45.9040308@trash.net> <4392630F.4040008@eurodev.net>
	<439313B2.50601@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <439313B2.50601@trash.net>
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
Date: Sun, 04 Dec 2005 17:05:06 +0100

> It doesn't even affect compatiblity, userspace can send both
> u_int8_t or u_int16_t, the binary representation will look the same.

On little-endian, yes.  But on big-endian you'll get a byte-swapped
value for the case where userspace sends in a u8.
