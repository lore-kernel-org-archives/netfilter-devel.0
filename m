From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 23:31:49 -0700 (PDT)
Message-ID: <20051011.233149.40160652.davem@davemloft.net>
References: <434C3485.2000700@frankengul.org>
	<20051011.153257.75932845.davem@davemloft.net>
	<20051012062218.GA2712@frankengul.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: seb@frankengul.org
In-Reply-To: <20051012062218.GA2712@frankengul.org>
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

From: seb@frankengul.org
Date: Wed, 12 Oct 2005 08:22:18 +0200

> After building, the modules_install reports the symbol undefined.
> Well, I see now that it is only a lack of EXPORT_SYMBOL.

Aha, that makes sense.

> All smp arch used cpu_online_map and cpu_possible_map but sparc which
> used phys_cpu_present_map (a specificity of the sparc port I presume).

Yes, we do this because since we lack cpu hotplug support
this means "cpu present"=="cpu possible".
