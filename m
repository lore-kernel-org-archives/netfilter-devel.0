From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: stealing packets
Date: Mon, 24 Nov 2003 00:46:02 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311240039520.6878-100000@filer.marasystems.com>
References: <20031123223428.22677.qmail@web60708.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Zeeshan Ali <zeelists@yahoo.com>
In-Reply-To: <20031123223428.22677.qmail@web60708.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 23 Nov 2003, Zeeshan Ali wrote:

> still worried about that. Now here is my next
> question: Is it possible that after stealing a packet
> inside any of the hooks, i can put the packet back
> again (without creating an infinite loop) sometime later.

If the hook returns NF_QUEUE then the packet will be sent to the netfilter 
queue handler from where it can later be reinjected and will then continue 
on the next hook.

Regards
Henrik
