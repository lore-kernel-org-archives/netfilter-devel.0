From: "David S. Miller" <davem@davemloft.net>
Subject: Re: problem with active ftp masqarading in kernel newer than
 2.6.10-rc1
Date: Sun, 24 Apr 2005 20:57:36 -0700
Message-ID: <20050424205736.5b15f089.davem@davemloft.net>
References: <20050421222803Z136196-2326+375@kps1.test.onet.pl>
	<4268BA1C.1080902@trash.net>
	<20050424195714.61edbfc3.davem@davemloft.net>
	<426C6748.2080907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: mateusz@republika.pl, linux-net@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426C6748.2080907@trash.net>
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

On Mon, 25 Apr 2005 05:43:04 +0200
Patrick McHardy <kaber@trash.net> wrote:

> David S. Miller wrote:
> > Patrick, as you've seen I've applied this sequence number fixing patch
> > and the conntrack one to handle SYN+ACK+PSH correctly.
> > 
> > But I seem to remember there was some third pending netfilter fix you
> > want me to put into 2.6.12, but I can't find it anywhere.  Am I right?
> > If so, please point me at it.
> 
> There were two more fixes for 2.6.12, I've attached them to this mail
> and cut-n-pasted the descriptions below.

Thanks, I'll try to get those to Linus by tomorrow night, as I've
already sent a batch to him this evening.
