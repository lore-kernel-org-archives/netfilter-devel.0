From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 08:34:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310200820260.23179-100000@filer.marasystems.com>
References: <3F934FFD.7090700@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F934FFD.7090700@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 20 Oct 2003, Patrick McHardy wrote:

> Sounds like a nice solution. I favour the permanent resorting for these 
> reasons:

> - all temporary memory allocations should be released before
> ctnetlink_dump is left, not in ctnetlink_done since we don't know if and
> when the read will continue. this means sorting multiple times is
> required.

Sorting multiple times is indeed needed if not doing a permanent resort,
as you do not want to keep the bucket locked for a long period. Even if 
you knew the read would continue you can not save the temporary sorted 
list.

> - we can use some sorting algorithm which benefits from pre-sorted
> input. this would give better average performance. IIRC new conntracks
> are added at the head of the chains, so if we sort and walk backwards
> through the chains we only have to resort after an id counter wrap.

Could work. In such case the bucket should at most times be sorted
naturally with no need to resort. There is a few theoretical races
where entries may be inserted in another order (more so on SMP), but these
are hopefully relatively rare.

Regards
Henrik
