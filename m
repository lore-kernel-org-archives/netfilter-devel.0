From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 15:52:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
	<Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
	<a60102c30510170647w24a8928o@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: JC <bikkit@gmail.com>
In-Reply-To: <a60102c30510170647w24a8928o@mail.gmail.com>
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

On Mon, 17 Oct 2005, JC wrote:

>> For the exact same reason the match also hotdrops fragments which would
>> overwrite the TCP header.
>>
>> In theory just the second criteria is a must (drop fragments which could
>> override an earlier decision), but as it's there the first also makes
>> sense to drop the first as we can not allow a fragment filling in the
>> missing pieces.
>
> Could someone please explain these two?

An IP fragment with offset 1 can overwrite parts of the TCP header, and if 
this check is not there an attacker could bypass port matches in iptables 
by sending the packet in two fragments where the first fragment (which is 
used by the tcp match) has ports which is allowed by the ruleset and later 
the second fragment (which is ignored by the tcp match) overwrites the 
port numbers with ports which would not be allowed by the ruleset.

Regards
Henrik
