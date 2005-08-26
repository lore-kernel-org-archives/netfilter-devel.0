From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 12:20:36 -0700 (PDT)
Message-ID: <20050826.122036.09917208.davem@davemloft.net>
References: <430F1C07.5020305@trash.net> <20050826151655.GA5606@linuxace.com>
	<430F342C.7050007@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kernel@linuxace.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <430F342C.7050007@trash.net>
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
Date: Fri, 26 Aug 2005 17:24:28 +0200

> I think documenting the issue is enough, users have plenty of ways of
> shooting themselves.

I agree, let's not burdon new code with "this feature is dangerous"
ifdefs.
