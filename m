From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 04/39]: ipt_TCPMSS: reformat
Date: Wed, 20 Sep 2006 11:19:57 -0700 (PDT)
Message-ID: <20060920.111957.45154196.davem@davemloft.net>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
	<20060920082448.14636.28002.sendpatchset@localhost.localdomain>
	<4511200C.1040706@drugphish.ch>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, w@1wt.eu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ratz@drugphish.ch
In-Reply-To: <4511200C.1040706@drugphish.ch>
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

From: Roberto Nibali <ratz@drugphish.ch>
Date: Wed, 20 Sep 2006 13:03:40 +0200

> Would something like this be a candidate for 2.4 as well?

Like Patrick, I believe that 2.4.x is in such deep extreme
maintainence mode that we should only ever consider pushing patches
that users are actually hitting, or else we'll be backporting a lot of
stuff and potentially causing more harm than good via potential
regressions.

I really don't like this trigger-happy "maybe backport this fix to
2.4.x" reaction some people have. :-/

Heck, for many of us 2.4.x is so old that we don't even have systems
any longer that we can test them on since most distributions compile
glibc in such a way that using kernels older than 2.6.x is basically
impossible.
