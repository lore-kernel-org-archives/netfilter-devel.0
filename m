From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Fri, 5 Nov 2004 23:24:05 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411052320490.2017@filer.marasystems.com>
References: <20041104121522.GA16547@merlin.emma.line.org>
	<418A7B0B.7040803@trash.net>
	<20041104231734.GA30029@merlin.emma.line.org>
	<418AC0F2.7020508@trash.net> <418BE156.4020400@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@redhat.com>, linux-net@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <418BE156.4020400@eurodev.net>
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

On Fri, 5 Nov 2004, Pablo Neira wrote:

> Patrick, what about this? this way we save a copy to a buffer for linear 
> skbs.

You need to make sure you or any of the later string match/extract 
functions are not reading outside of the skb, after the current data 
segment.

>From what I could tell this was missing in your proposed change. If the 
helper sees a packet with a C as last byte it would read past the end of 
the skb, and without looking at the whole source I see it very likely 
there is operations on the data further down assuming a null terminated 
string..

Regards
Henrik
