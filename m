From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] New ipt_TTL target
Date: Sat, 27 Aug 2005 05:31:00 +0200
Message-ID: <430FDE74.7030800@trash.net>
References: <20050826183151.GD4226@rama.de.gnumonks.org>
	<20050826.123018.21840974.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050826.123018.21840974.davem@davemloft.net>
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

David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Fri, 26 Aug 2005 20:31:51 +0200
> 
> 
>>+config IP_NF_TARGET_TTL_INC
>>+	bool  'TTL incrementing support (DANGEROUS)'
>>+	depends on IP_NF_TARGET_TTL
>>+	help
>>+	  This option enables functionality to increment and set the TTL
>>+	  value of the IP header to arbitrary values.  This is EXTREMELY
>>+	  DANGEROUS since you can easily create immortal packets that loop
>>+	  forever on the network.  Please only enable if you really know
>>+	  that you will need it.
>>+
> 
> 
> I think it's best to kill this option.  Just put the "this is
> DANGEROUS" comment into the help text for IP_NF_TARGET_TTL, ok?
> 
> Similarly for the ipv6 hoplimit target too.

If we want to make sure, we simply print a message in the iptables
userspace command when someone uses this option. If this is too
extreme, a comment in the man-page will probably help to reach more
people than in the kernel-help text.
