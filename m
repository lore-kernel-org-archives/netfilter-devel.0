From: "jump lee" <zomby_cn@hotmail.com>
Subject: a question about ip_conntrack_max
Date: Thu, 12 Dec 2002 14:35:56 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F78gEj4v5iJarnJ3kEP000004e7@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


i am hacking ip_conntrack.
in function ip_conntrack_init (ip_conntrack_core.c), i can not understand 
this statement:

ip_conntrack_max=8*ip_conntrack_htable_size;

what's the reason of multiplying ip_conntrack_htable_size by 8?



_________________________________________________________________
MSN 8 with e-mail virus protection service: 2 months FREE* 
http://join.msn.com/?page=features/virus
