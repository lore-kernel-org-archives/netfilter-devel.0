From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:19:36 +0200
Message-ID: <200608141819.38152.max@nucleus.it>
References: <44E07BCD.8030206@trash.net> <200608141640.41759.max@nucleus.it>
	<44E08D3B.7040505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44E08D3B.7040505@trash.net>
Content-Disposition: inline
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

On Monday 14 August 2006 4:48 pm, Patrick McHardy wrote:

> Hmm .. recent does a table lookup during runtime and the table could be
> cached. That would improve things a bit, but in my opinion not enough
> to justify this patch. Same for hashlimit. What data would condition
> store exactly?

I need a pointer to per condition data, so that multiple rules with the same 
name refer to the same flag.
I can break userspace compatibility and store a pointer in the userspace 
structure. I just thought this could be useful to everyone (and let me 
maintain userspace compatibility along the way).

> Its actually quite clear what is needed. We want a userspace interface
> built on netlink, that acts on individual rules, not entire rulesets.
> There are a few more ideas, like handling negation centrally, allowing
> userspace to specify whether a target is terminal or not, allow multiple
> non-terminal targets in a row, etc, but nothing really fundamental.

I thought the current way of doing things was specifically designed to 
minimize softirq locking (especially with arbitarily long chains and 
arbitrary initialization code). We could switch to RCU lists, though...

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
