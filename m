From: Peter Surda <shurdeek@routehat.org>
Subject: Re: only first TCP SYN packet consulted in nat table chains - bug or feature?
Date: Tue, 22 Jun 2004 01:39:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621233905.GC7612@soldats.routehat.org>
References: <20040621200651.GB1323@iceberg.elsat.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040621200651.GB1323@iceberg.elsat.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 21, 2004 at 10:06:52PM +0200, Krzysztof Rusocki wrote:
> Hi,
Hi.

> However, quite recently I discovered that first TCP SYN packet's MSS is
> altered and latter SYN packets (in case of retransmission) have MSS
> unchanged (1460 - ether).
Yes.

> I'm just being curious here - is this a bug or feature?
Feature, nat is only traversed for packets with NEW state.

> For the time being I have changed that rule to use mangle table...
That's where it should be.

> Cheers,
> Krzysztof
Bye,

Peter Surda (Shurdeek) <shurdeek@routehat.org>, ICQ 10236103, +436505122023

-- 
   If Bill Gates had a dime for every time a Windows box crashed...
                ...Oh, wait a minute, he already does.
