From: Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Mon, 04 Apr 2005 23:58:50 +0800
Message-ID: <20050404235746.023E.LARK@linux.net.cn>
References: <20050404232509.0238.LARK@linux.net.cn>
	<20050404155157.GA32497@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050404155157.GA32497@roonstrasse.net>
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

Hi Max Kellermann,

Then perhaps this applies to all three of rtsp, h323 and mms?

On Mon, 4 Apr 2005 17:51:57 +0200, Max Kellermann <max@duempel.org> wrote:

> > Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
> > unable to find ladd slot in src /tmp/pom-10691/include/linux/netfilter_ipv4/ip_conntrack.h 
> > (./h323-conntrack-nat/linux-2.6.11/./include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3)
> 
> ah damn, that file is still in the pom-ng svn repository. It is
> obsolete and was deleted by a patch long ago, but that was forgotten.
> 
> Delete the file ip_conntrack.h.ladd_3 from your working copy, and it
> should finally work..
> 
> Max
> 



-- 
  lark
