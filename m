From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update raw patch in POM
Date: Wed, 22 Jun 2005 02:32:01 +0200
Message-ID: <42B8B181.4020607@trash.net>
References: <42A5B144.3090005@tac.ch> <42A625DA.7090807@eurodev.net>
	<42A6AB19.2040106@tac.ch> <42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch> <42B67BEC.1090105@tac.ch>
	<20050621003441.GI8335@postel.suug.ch>
	<42B76474.8080209@eurodev.net>
	<20050621111328.GK8335@postel.suug.ch> <42B81D75.8090205@trash.net>
	<20050621215027.GP8335@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050621215027.GP8335@postel.suug.ch>
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

Thomas Graf wrote:'
> This patch seems fine but it cannot fix the bug. The fact that we
> trigger the BUG() implies a serious problem which is that we'd be
> calling destroy() on a conntrack entry which was never allocated.

Sorry, I didn't follow the entire thread and there seem to be a lot
of BUG()s :) Which one exactly are you refering to?

Regards
Patrick
