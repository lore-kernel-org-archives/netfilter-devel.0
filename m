From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 1/4]: Fix HW checksum handling in ip_queue/ip6_queue
Date: Tue, 23 Aug 2005 09:20:48 -0700 (PDT)
Message-ID: <20050823.092048.128361911.davem@davemloft.net>
References: <4309166D.9010706@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4309166D.9010706@trash.net>
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
Date: Mon, 22 Aug 2005 02:03:57 +0200

> (the ip_queue fix could also go directly in 2.6.13 IMO).

I had to munge the patch a lot to get it to apply to
2.6.13 (too many 2.6.14 dependencies in the patch hunks
:-), but I did add it to my 2.6.13 tree.

Thanks.
