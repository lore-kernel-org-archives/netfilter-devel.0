From: zhi wang <pangy2004@yahoo.com>
Subject: Re: current pom-ng's nfnetlink doesn't apply cleanly to kernel 2.4.22
Date: Sun, 18 Apr 2004 03:10:22 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040418101022.15235.qmail@web41703.mail.yahoo.com>
References: <Pine.LNX.4.44.0404181102460.4242-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404181102460.4242-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> Maybe the patch does indeed depend on some other patch not listed in the
> dependencies. Where does it fail?  
> 
I apply the nfnetlink, and the result is as:
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] f
apply_dependencies: successfully applied netfilter-docbook
apply_dependencies: successfully applied nf-log
apply_dependencies: successfully applied raw
apply_dependencies: unable to apply dependent ctstat: ERROR (2 rejects out of
15 hunks)

There is one .rej file generated: ip_conntrack_core.c.rej.
For example, the first several lines of it read:
       ***************
       *** 61,71 ****
       static LIST_HEAD(helpers);
       unsigned int ip_conntrack_htable_size = 0;
       int ip_conntrack_max = 0;
     - static atomic_t ip_conntrack_count = ATOMIC_INIT(0);
       struct list_head *ip_conntrack_hash;
       static kmem_cache_t *ip_conntrack_cachep;
       struct ip_conntrack ip_conntrack_untracked;
                                                                               
                                             
       extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
                                                                               
                                             
       static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
       --- 61,73 ----
       ......
It is because ip_conntrack_max is defined as a static global variable in the
original 2.4.22 kernel, maybe some other patches has changed it silently:).

----
Regards
wang,zhi


	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
