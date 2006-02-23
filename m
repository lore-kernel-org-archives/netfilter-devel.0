From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Thu, 23 Feb 2006 20:10:06 +0900 (JST)
Message-ID: <200602231110.k1NBA6FV008922@toshiba.co.jp>
References: <43FBD887.9040409@netfilter.org>
	<200602221301.k1MD1lIb015798@toshiba.co.jp>
	<43FD8509.9070203@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43FD8509.9070203@trash.net>
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
Date: Thu, 23 Feb 2006 10:48:57 +0100

> Harald and me were actually talking about simplifying the helper lookup
> by making the dst part of an expectation fixed (for ip_conntrack). With

I got time to read deeply the patch from him yesterday midnight.
(but that was for nf_conntrack). Simplifying the helper lookup is fine to
me.

> nf_conntrack l3num is in the src-part of the tuple, but thats just
> for memory-efficiency, it can be treated equally to protonum and the
> mask can be eliminated.

Yes, that patch actually eliminates it.

-- Yasuyuki Kozakai
