From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: find_appropriate_src() BUG  also exist in 2.4.24
Date: Thu, 04 Mar 2004 10:40:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078393236.770.30.camel@nienna.balabit>
References: <OFEFA89E24.FB9C3E65-ON48256E4D.002E762C@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: wanghtb@legend.com.cn
In-Reply-To: <OFEFA89E24.FB9C3E65-ON48256E4D.002E762C@legend.com.cn>
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

On Thu, 2004-03-04 at 09:32, wanghtb@legend.com.cn wrote:
> Still consider  a simple SNAT, without CONFIG_IP_NF_NAT_LOCAL selected 
> 
> [ Client A ] -----> [ Box B ] ----> [ Server C ]
> iptalbes -A POSTROUTING -t nat -p udp  -j SNAT --to-source B:2000-3000
> 
> when two udp connection built:
> ct1: ORIG A.1---> C.1   REPLY  C.1 ---> B.2000
> ct2: ORIG B.2000 ---> C.2 REPLY C.2 ---> B.2000
> 
> then the third will hang on the system
> 
> B.2000 ---> C.1
> 
> 
> So, I think ip_nat_local_fn() should be called in any situation:-)

  Instead of calling ip_nat_local_fn() in any situation, I think that
the endless loop should be fixed in ip_nat_setup_info(). The problems
are caused by get_unique_tuple() always returning the same tuple, which
is already used by a confirmed connection, and ip_nat_setup_info()
calling get_unique_tuple() forever.

  In 2.6.3, this should be solved, since get_unique_tuple() will check
the tuple returned by find_appropriate_src() to make sure it's not yet
used. This check is missing from the Linux 2.4 branch.

  In addition, I still think that src_cmp() is mistaken, it passes
errorneous arguments (the original source of the connection instead of
the SNAT-ted source) to in_range().

  Also, see Rusty's patch in his reply to Karlis Peisenieks' mail:

http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012388.html

It is especially interesting, since he proposes that the whole loop
should be removed from ip_nat_setup_info(), and that the check in
ip_conntrack_alter_reply() is not needed anyway.

  Harald, or someone in the core team, what is your opinion?

-- 
 Regards,
   Krisztian KOVACS
