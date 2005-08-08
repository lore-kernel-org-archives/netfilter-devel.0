From: "David S. Miller" <davem@davemloft.net>
Subject: Re: ipsec in transport mode is not handled correctly
Date: Mon, 08 Aug 2005 08:37:59 -0700 (PDT)
Message-ID: <20050808.083759.41635231.davem@davemloft.net>
References: <20050808103459.e1sm3gpj4wgs4coc@www.milivojevic.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: alex@milivojevic.org
In-Reply-To: <20050808103459.e1sm3gpj4wgs4coc@www.milivojevic.org>
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

From: Aleksandar Milivojevic <alex@milivojevic.org>
Subject: ipsec in transport mode is not handled correctly
Date: Mon, 08 Aug 2005 10:34:59 -0500

> I've noticed that on kernel-2.6.9-11.EL IPSec packets go through INPUT chain of
> filter table only once if I use IPSec in transport mode.  They go there only
> encrypted (ESP packet), but there's no second pass with decrytped packet.

Well known problem, we're working on a solution constantly but
it's not easy to fix.
