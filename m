From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: handling the termination of 'expected' connection
Date: Mon, 13 Feb 2006 22:54:17 +0900 (JST)
Message-ID: <200602131354.k1DDsI87008506@toshiba.co.jp>
References: <1138725243.16037.253194510@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: iler_ml@fastmail.fm
In-Reply-To: <1138725243.16037.253194510@webmail.messagingengine.com>
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

From: iler_ml@fastmail.fm
Date: Tue, 31 Jan 2006 08:34:03 -0800

> Hello,
> 
> I am making the conntrack module similar to ip_conntrack_ftp.c, 
> but additionally I need to track the termination (or expiry) of
> the 'expected' connection.  Thus I need a callback from 
> 'ip_conntrack_core.c' when the 'expected' connection is terminated 
> or expired. I think I need to patch 'ip_conntrack_core.c' for that ? 
> 
> Which points in 'ip_conntrack_core.c' are the right points to hook
> for such event ? 
>
> I though I would patch 'ip_conntrack_core.c' to call my callback when
> struct ip_conntrack_core.c is deallocated. Does this sound right ?

expectation_timed_out() is called when expectation timer is expired.

But it's too hard to take care of the case that expectations are destroyed
by other reason. ip_conntrack_expect_put() might be called with holding lock.

Ideally, caller of ip_conntrack_expect_put() should not hold it...

-- Yasuyuki Kozakai
