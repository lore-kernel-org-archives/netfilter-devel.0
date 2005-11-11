From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [netfilter-core] Re: [PATCH] ip_conntrack_proto_tcp
Date: Fri, 11 Nov 2005 11:48:01 -0800 (PST)
Message-ID: <20051111.114801.112784817.davem@davemloft.net>
References: <1131637730.14044.12.camel@quant> <437495E7.5050500@eurodev.net>
	<4374A369.6020308@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: vlad@storewiz.com, coreteam@netfilter.org, pablo@eurodev.net,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4374A369.6020308@trash.net>
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
Date: Fri, 11 Nov 2005 14:58:01 +0100

> Unfortunately this is unlikely to happen, and if Linux itself
> accepts SYN|PSH, I don't see a reason why ip_conntrack shouldn't
> as well.

I totally agree.
