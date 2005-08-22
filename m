From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Sun, 21 Aug 2005 19:14:01 -0700 (PDT)
Message-ID: <20050821.191401.69380622.davem@davemloft.net>
References: <430887CA.1080505@trash.net>
	<20050821.153436.09264518.davem@davemloft.net>
	<430918C7.2090502@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <430918C7.2090502@trash.net>
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
Date: Mon, 22 Aug 2005 02:13:59 +0200

> David S. Miller wrote:
> > Sorry, that's the 2.4.x code, perhaps it should be converted
> > to use either vmalloc() of compat_alloc_user_space().
> 
> I'll look into it after fixing the 2.6 compat code.

Thanks a lot Patrick.
