From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: additional netfilter queue verdict
Date: Tue, 4 May 2004 09:24:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405040922030.25896-100000@filer.marasystems.com>
References: <200405032125.46793.rmiller@duskglow.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Russell Miller <rmiller@duskglow.com>
In-Reply-To: <200405032125.46793.rmiller@duskglow.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 3 May 2004, Russell Miller wrote:

> NF_CONTINUE
> 
> This verdict would remove the packet from the queue and allow processing to 
> continue in the table that the rule is part of.

This is not technically possible due to the way QUEUE works.. QUEUE is a 
Netfilter operation, not an iptables operation.

> In the alternative or in addition, an NF_REJECT verdict might be nice too, but 
> I note there are multiple ways to reject a packet, and perhaps it would be 
> too much trouble to implement.

REJECT does not exists in Netfilter. This is an iptables thingy...


I think what would benefit you and many others of QUEUE is to add a nfmark 
field in the verdict. This has been discussed many times and done by 
several people but nobody seems to have submitted their results for 
inclusion in pom-ng...

Regards
Henrik
