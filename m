From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Wed, 17 Mar 2004 14:37:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079530631.810.117.camel@nienna.balabit>
References: <Pine.LNX.4.44.0403171351490.9283-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Vijaya Chandra Vupputuri <vijay@tachyontech.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403171351490.9283-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Wed, 2004-03-17 at 14:04, Henrik Nordstrom wrote:
> nothing. Thinking.. ah, now I get it. The problem is that you are doing
> traffic local->local and that the NAT code then gets confused as it sees
> the same packet twice in each direction, and as no null mapping was
> created the first time for the "local" side PREROUTING tries to when it
> sees the traffic coming "in" (from itself).

  Yes, this is the case.

> The solution I mentioned above should workI think, but my gut feeling is
> that it would be better to simply have the hooks of CONFIG_IP_NF_LOCAL_NAT
> always enabled and not try to optimize local traffic by making it such
> special case for NAT to deal with.

  I agree. BTW, this is the patch which removed the nat hook on
LOCAL_OUT:

http://lists.netfilter.org/pipermail/netfilter-devel/2003-October/012617.html

-- 
 Regards,
   Krisztian KOVACS
