From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Mon, 10 Oct 2005 15:04:31 -0700 (PDT)
Message-ID: <20051010.150431.19652848.davem@davemloft.net>
References: <20051010164141.GG5627@rama>
	<20051010.141518.60492651.davem@davemloft.net>
	<434AE017.2020905@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <434AE017.2020905@trash.net>
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
Date: Mon, 10 Oct 2005 23:41:43 +0200

> Even better would be a function returning the CPU ID as "physical"
> ID, skipping holes in the space. This would allow to save the memory
> for unused CPU IDs. Maybe a small table mapping "virtual" to "phyiscal"
> IDs?

We used to have this and it was really ugly and error prone.

I like the discontiguous cpu ID space much better.

I was so happy when I could blow away those virtual<-->physical cpu ID
mappings.  People got it wrong all the time and it makes hotplug cpu
support more difficult.
