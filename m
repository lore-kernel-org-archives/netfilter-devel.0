From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Don't increase master refcount on expectations
Date: Wed, 07 Sep 2005 11:00:04 +0900 (JST)
Message-ID: <200509070200.j8720AFV024325@toshiba.co.jp>
References: <430E2DF9.8060802@eurodev.net>
	<431B333F.8030902@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <431B333F.8030902@trash.net>
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
Subject: Re: [PATCH] Don't increase master refcount on expectations
Date: Sun, 04 Sep 2005 19:47:43 +0200

> Pablo Neira wrote:
> > As it's been discussed [1][2]. We shouldn't increase the master 
> > conntrack refcount for non-fulfilled conntracks. During the conntrack 
> > destruction, the expectations are always killed before the conntrack 
> > itself, this guarantees that there won't be any orphan expectation.
> 
> Applied, thanks. Is it correct that this also fixes the untriggerable
> deadlock Yasuyuki noticed?

As far as I read, yes.

BTW, I'll send patches on this for nf_conntrack.
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
