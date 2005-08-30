From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Tue, 30 Aug 2005 15:40:22 +0900 (JST)
Message-ID: <200508300640.j7U6eMk3004340@toshiba.co.jp>
References: <4312EE29.9040102@trash.net>
	<200508291539.j7TFduLF019555@toshiba.co.jp>
	<20050829154927.GU4292@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050829154927.GU4292@rama.de.gnumonks.org>
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


From: Harald Welte <laforge@netfilter.org>
Date: Mon, 29 Aug 2005 17:49:27 +0200

> Yes. ipt_{conntrack,state,helper} should however still be modified to
> use struct ip_conntrack or struct nf_conntrack depending on the
> compile-time decision.  Please make up your mind on the best possible
> implementation.  Probably a large "#ifdef CONFIG_NF_CONNTRACK #else
> #endif" section for each of the matches.  It's not nice, but since it
> only affects three matches (and we don't pay a performance penalty this
> way) I think it's ok.

Well, I think the large block surrounded with #ifdef - #endif doesn't match
the initial goal that avoids similar codes and its impact is same as
similar files. So I was exploring the way to minimize the block in the matches
by using glue functions/macros.


> Yes, I was already thinking about nf_conntrack based ipv4 nat and
> playing with some extremely early code, but abandoned it since other
> issues are higher priority.  I think I'll get back to it at end of
> October / beginning of November.

Great!

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
