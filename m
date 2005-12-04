From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: P2P implementation for netfilter NAT
Date: Sun, 04 Dec 2005 21:26:49 +1100
Message-ID: <1133692009.30188.27.camel@localhost.localdomain>
References: <001801c5f6b3$539b1b20$3478fea9@acer21ce70712f>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesse Peng <tzuhsi.peng@msa.hinet.net>
In-Reply-To: <001801c5f6b3$539b1b20$3478fea9@acer21ce70712f>
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

On Fri, 2005-12-02 at 04:10 +0800, Jesse Peng wrote:
> Dear All
> Here is the patch for p2p implementation.Please reference the links
> below:
> 1.Logic to implement.
> https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017479.html 
> 2.The Last draft by Dan Kegel.
> http://www.brynosaurus.com/pub/net/p2pnat.pdf
> 
> Hello Rusty
> Like what we discussed as following 2 points
> 1.hash_by_modified_source need be checked and added by conntracks
> being SNATP2Ped.As the checking code is hacked in
> ip_nat_used_tuple,and adding code in ip_nat_setup_info.All incoming
> hairpin or holepunch try be checked and added in the ip_nat_rule_find
> hacking.

> 2.delay tcp timeout for immediate reset by counterparts in case they
> are old version and fail to take hairpin or holepunch reaction.(Maybe
> We don't need do this any more,because that will only terminate our
> initiation,but while they initiate,we are happy to handle the
> holepunch and the hairpin! :) ) .

Hi Jesse,

	Your patch seems incomplete, and anyway it's been mangled by your
mailer.  Sorry I've been slow to respond, but a on a quick read I think
you're going in the right direction.  Perhaps try an attachment?

Thanks!
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
