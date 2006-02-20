From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 14/13]: Fix NAT PMTUD problems
Date: Sun, 19 Feb 2006 22:27:19 -0800 (PST)
Message-ID: <20060219.222719.126324788.davem@davemloft.net>
References: <43F77A08.4030308@trash.net>
	<20060219.004445.68815246.davem@davemloft.net>
	<43F830CC.4080502@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43F830CC.4080502@trash.net>
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
Date: Sun, 19 Feb 2006 09:48:12 +0100

> David S. Miller wrote:
> > I think this belongs in net-2.6, is that where you want me to
> > put it?
> 
> OK. There were enough netfilter patches touching critical spots
> in the last -rc to make me feel a bit uncomfortable, which is
> why I'm trying to keep it to a minimum.

I've applied it.  This is just too serious a regression to
let slip into 2.6.16-final, I think.

Thanks.
