From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Wed, 17 Mar 2004 12:48:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079524124.813.103.camel@nienna.balabit>
References: <Pine.LNX.4.33.0403121424070.20054-100000@blackhole.kfki.hu>
	 <1079458116.843.62.camel@nienna.balabit>  <1079516281.4874.11.camel@vijay>
	 <1079522164.812.93.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
In-Reply-To: <1079522164.812.93.camel@nienna.balabit>
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

On Wed, 2004-03-17 at 12:16, KOVACS Krisztian wrote:
>   Yes, in theory. To trigger the bug, you should connect _from_ the
> gateway to itself. (Note that the ruleset is somewhat flawed, since it
> should redirect only traffic coming in through the LAN interface.) I
> used netcat to connect:
> 
> # nc 10.1.0.1 80

  I think I've got it. When such a connection is initiated, the SYN goes
out on the LOCAL_OUT hook, and gets confirmed at POSTROUTING. Then it
arrives in PREROUTING, where it's NAT-ted according to the REDIRECT
rule. And here is the problem: ip_conntrack_alter_reply() modifies the
reply tuple of an already confirmed (= hashed) connection. This is the
place where we corrupt the hash.

  When CONFIG_IP_NF_LOCAL_NAT is on, alloc_null_binding() is called on
LOCAL_OUT, so that ip_nat_fn() will skip the packet when it is seen on
PREROUTING.

-- 
 Regards,
   Krisztian KOVACS
