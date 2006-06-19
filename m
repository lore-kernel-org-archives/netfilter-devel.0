From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] entry_data
Date: Tue, 20 Jun 2006 01:13:55 +0200
Message-ID: <44972FB3.5070603@trash.net>
References: <200606050029.08602.max@nucleus.it> <448FD0F6.3010506@anduras.de>
	<4496E037.2000706@trash.net> <200606200035.07197.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606200035.07197.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Monday 19 June 2006 7:34 pm, Patrick McHardy wrote:
> 
> 
>>Yes, userspace ignores these fields. I still haven't really made up my
>>mind about this patch yet. I don't like the void ** approach very much,
> 
> 
> I understand your concerns, but it's either that or feeding it its own struct 
> xt_entry_match *. This would be awfully circular, while the practice of 
> passing someting * to functions is widespread. This only happens to be 
> applied to a void *.

I guess I just like externally allocated storage better (and a .privsize
field or something in the match structures). It avoids each match having
to deal with memory allocation failures and more complicated cleanup
code. Currently some matches store state in the structures shared with
userspace and keep a pointer to the first per-CPU copy so there is only
a single state on SMP, others allocate memory and keep a pointer in the
shared struct, yet others keep global state and do lookups based on some
identifier in the shared struct. The first two cases really just want
some amount of memory that is shared between per-CPU data and are happy
with externally allocated memory, the last one is usually used to share
state between selected instances of matches or targets, which will
always need to be handled internally.

So I think we should introduce a .priv_size field or something in struct
xt_match/xt_target and pass memory allocated by xtables to the matches
and targets.
