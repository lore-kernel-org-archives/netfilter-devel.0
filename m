From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Fw: [Bug 133788] New: ip_conntrack_in: Frag of proto 17
Date: Wed, 29 Sep 2004 10:41:31 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291038080.11661@filer.marasystems.com>
References: <20040928130512.57479400.davem@davemloft.net>
	<20040928220532.GN29961@sunbeam.de.gnumonks.org>
	<4159F559.3040400@trash.net>
	<20040929074328.GB31674@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040929074328.GB31674@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004, Harald Welte wrote:

>> Here is the patch. Untracked and already tracked (loopback) packets
>> are not defragmented, but the check in ip_conntrack_in for
>> untracked/already tracked is after the check for fragments.
>> This patch moves it up.
>
> Sometimes I feel like I'm blind.  Thanks, Patrick.

Hmm..

loopback traffic is seen twice by netfilter, once when being sent, once 
when being received. If a packet larger than the loopback MTU is sent this 
will get fragmented (by conntrack) and then reinjected..  has it been 
fixed so the reinjected traffic (which is the same skbuff) has it's 
conntrack state cleared?

I remember this issue coming up before wrt NAT where loopback packets were 
seen as NEW twice, but I don't remember what the fix was.

Regards
Henrik
