From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: prohibiting iptables to insert a rule twice
Date: Thu, 6 May 2004 13:41:54 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405061338260.30286-100000@filer.marasystems.com>
References: <409A239B.2040409@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <409A239B.2040409@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 May 2004, Ozgur AKAN wrote:

> hmm.. can you please give an example?  I can not imagine when it shall 
> be meaningful.

One example is when MARK target for the mark to apply for a number of
following rules:

iptables -t mangle -j MARK --set-mark A
[number of rules using mark A]
iptables -t mangle -j MARK --set-mark B
[number of rules using mark B]
iptables -t mangle -j MARK --set-mark A
[more rules using mark A]

I am not saying it is the best design, but still useful.

Regards
Henrik
