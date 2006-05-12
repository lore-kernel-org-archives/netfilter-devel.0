From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Fri, 12 May 2006 14:49:31 +0200
Message-ID: <4464845B.3010502@trash.net>
References: <20060507093640.GF11191@w.ods.org>
	<egts52hm2epfu4g1b9kqkm4s9cdiv3tvt9@4ax.com>
	<20060508050748.GA11495@w.ods.org>
	<20060507.224339.48487003.davem@davemloft.net>
	<44643BFD.3040708@trash.net>
	<9a8748490605120409x3851ca4fn14fc9c52500701e4@mail.gmail.com>
	<44647280.1030602@trash.net>
	<9a8748490605120513w4b078642k816dfef6ab907823@mail.gmail.com>
	<20060512124041.GA31714@w.ods.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sfrost@snowman.net, gcoady.lk@gmail.com, laforge@netfilter.org,
	Jesper Juhl <jesper.juhl@gmail.com>, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, marcelo@kvack.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20060512124041.GA31714@w.ods.org>
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

Willy Tarreau wrote:
> Please post it to the list, this coding style needs far more than two
> pairs of eyes to be fixed. It has already discouraged several people,
> the more we will be, the least pain we will feel :-)

:)

I actually just got to fed up with this garbage (once again) and started
rewriting it from scratch, which looks like a lot less pain. I'll look
into these loops again for 2.4 and 2.6.17 once I'm done doing that.
