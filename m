From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking
Date: Wed, 19 Feb 2003 09:57:19 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E52C85F.40800@snapgear.com>
References: <4.2.0.58.20030119145120.00b1c6f0@avocetgw> <20030217190023.GF11812@sunbeam.de.gnumonks.org> <3E51836B.8030207@snapgear.com> <20030218093812.GM11812@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Paul Mielke <paulm@routefree.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Tue, Feb 18, 2003 at 10:50:51AM +1000, Philip Craig wrote:
> 
>>>Can you please test if your setup works with this patch?
>>
>>Paul and I have tested that the attached patch fixes the problem.
>>It is similar to yours, except that it returns earlier.  I don't
>>think the calls to place_in_hashes() and do_bindings() are
>>necessary if we just need to return NF_ACCEPT without doing any
>>NAT?
> 
> 
> yes, but  I can imagine the case where somebody actually _does_ want to
> do some nat from the expectfn() - and we should keep that option open...

That is exactly the problem this patch is solving.  We want
to do NAT in expectfn() for PPTP, but the #ifdef for local NAT
was too early and expectfn() wasn't being called at all.  So this
patch moves the #ifdef into a code path that isn't followed if
expectfn() needs to be called.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
