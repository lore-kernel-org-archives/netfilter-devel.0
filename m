From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Sun, 07 May 2006 22:43:39 -0700 (PDT)
Message-ID: <20060507.224339.48487003.davem@davemloft.net>
References: <20060507093640.GF11191@w.ods.org>
	<egts52hm2epfu4g1b9kqkm4s9cdiv3tvt9@4ax.com>
	<20060508050748.GA11495@w.ods.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sfrost@snowman.net, gcoady.lk@gmail.com, laforge@netfilter.org,
	jesper.juhl@gmail.com, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, marcelo@kvack.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: willy@w.ods.org
In-Reply-To: <20060508050748.GA11495@w.ods.org>
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

From: Willy Tarreau <willy@w.ods.org>
Date: Mon, 8 May 2006 07:07:48 +0200

> I wonder how such unmaintainable code has been merged in the first
> place. Obviously, Davem has never seen it !

Oh I've seen ipt_recent.c, it's one huge pile of trash
that needs to be rewritten.  It has all sorts of problems.

This is well understood on the netfilter-devel list and
I am to understand that someone has taken up the task to
finally rewrite the thing.
