From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Don't increase master refcount on expectations
Date: Wed, 07 Sep 2005 14:01:05 +0900 (JST)
Message-ID: <200509070501.j87516JU006636@toshiba.co.jp>
References: <430E2DF9.8060802@eurodev.net>
	<000801c5aa3a$5bd49250$1501a8c0@test1>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net, kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jesse@deansoft.com.tw
In-Reply-To: <000801c5aa3a$5bd49250$1501a8c0@test1>
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


Hi,

From: "JessePeng" <jesse@deansoft.com.tw>
Date: Fri, 26 Aug 2005 20:33:27 +0800

> The scenario is that then I had a custom solution which takes advantage on
> helper-expectation framewrok.According to this scenario,a master will expect
> many children simultaniously.And not only each child's first packet which
> fullfill the expect relies on its master for nat decision,but also the
> scenario relies on the master for decision made on itself while one of its
> children's replying packet reaches.And each children's replying packet will
> not only put itself but also remove its conntrack.So the scenarion raises 2
> problems:
> 1.Then without responsing from netfilter,All I can do is but doing some
> custimized work to ip_conntrack_put the master to prevent the master from
> hanging forever.(After quite a period, they patched the context.)
> 2.After All expects being fullfilled,it is still nacessary that the master
> be referenced.So it looks reserving a refcount on the master after the
> fullfillment doesn't push things too far.
> 
> So,my opinion is if it is necessary to keep refcount after
> fullfillment?And,I suggest that my past suggestion be referrenced.

Well, it's questionable that I correctly understand your scenario, but
I think there is no problem. 1. As Pablo said, expectations in list are
destroyed by its master before master is destroyed, so ip_conntrack_put()
doesn't cause problem. And because the refcount of master conntrack is
incremented when the expected packets arrived, master conntrack can be kept
after that. See init_conntrack() in detail.

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
