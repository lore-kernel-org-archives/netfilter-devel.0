From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack allocation issue
Date: Fri, 01 Dec 2006 13:14:09 +0900 (JST)
Message-ID: <200612010414.kB14EBhN029315@toshiba.co.jp>
References: <456EFC8F.2000507@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <456EFC8F.2000507@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 30 Nov 2006 16:45:19 +0100

> I've added these three patches to fix the allocation problems.
> I don't want to add the new module option introduced by
> Jozsef's patch since the current situation is just ridiculous,
> we need to search for both helpers and expectations twice for
> every new connection, so this needs to be redesigned anyway.

I agree.

> It seems to work fine in some quick testing. This was the
> last problem I'm aware of, so I'm probably going to push
> all patches soon.
> 
> Last thing is the helper renaming, any objections to prefix
> all helpers with nf_conntrack_helper_?

no objection.

-- Yasuyuki Kozakai
