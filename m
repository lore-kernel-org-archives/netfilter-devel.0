From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: IPT_ENTRY_ITERATE
Date: Thu, 23 Sep 2004 09:43:17 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0409230932400.20426@tux.rsn.bth.se>
References: <415274A7.9030203@rediffmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Swapnil Nagle <swapsn@rediffmail.com>
In-Reply-To: <415274A7.9030203@rediffmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 23 Sep 2004, Swapnil Nagle wrote:

> I am embarassed to ask this but : where is IPT_ENTRY_ITERATE defined ?

Don't be.

> grep shows  only one match :
>
> libiptc/libip4tc.c:#define ENTRY_ITERATE    IPT_ENTRY_ITERATE

These defines are used backwards... the function in libiptc.c is called
ENTRY_ITERATE() which then gets expanded to IPT_ENTRY_ITERATE() when it's
compiled for ipv4. This is because most of the libiptc code is shared
between ipv4 and ipv6 and we don't want massive code duplication when
it's mostly just the names of the structures that change.
(look at ENTRY_ITERATE in libip6tc.c and you'll see it's similar)

You want to look at ENTRY_ITERATE() in libiptc.c

/Martin
