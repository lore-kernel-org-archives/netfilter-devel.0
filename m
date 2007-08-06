From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Removal of ROUTE target - what now?
Date: Mon, 6 Aug 2007 10:12:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061011330.1735@fbirervta.pbzchgretzou.qr>
References: <BAY137-F28A4300A178941C885FAB2A3E50@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, david@davidcoulson.net
To: John Lumby <johnlumby@hotmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <BAY137-F28A4300A178941C885FAB2A3E50@phx.gbl>
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


On Aug 5 2007 21:27, John Lumby wrote:
> Well, i tested with and without - seems to work in each case.
> I had never looked at RPF before but this particular interface comes up with
> RPF enabled, and I first disabled it, then established a few conversations
> (SMTP)  which succeeded, then (without dropping the ppp1 IP interface)
> echo 1 >/proc/sys/net/ipv4/conf/ppp1/rp_filter
> and sent a few more SMTP conversations and they succeeded too.
> Don't know if that was a valid test.

Does it still work when the following three are set to 1?
	/proc/sys/net/ipv4/conf/all/rp_filter
	/proc/sys/net/ipv4/conf/ppp0/rp_filter
	/proc/sys/net/ipv4/conf/ppp1/rp_filter

> P.S.   The patch-o-matic extras web page still refers to ipt_ROUTE

Yeah it lists a lot of other stuff too, that has either been merged
or deleted.


	Jan
-- 
