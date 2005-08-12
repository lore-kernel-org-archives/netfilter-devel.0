From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Question about reference count of expectations in 2.6.14 tree
Date: Fri, 12 Aug 2005 03:19:02 +0200
Message-ID: <42FBF906.50906@eurodev.net>
References: <200508100111.j7A1Bok9010084@toshiba.co.jp>
	<20050811133545.GI4130@rama.de.gnumonks.org>
	<20050811135135.GJ4130@rama.de.gnumonks.org>
	<42FB6360.9010003@trash.net>
	<20050811192050.GH5353@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050811192050.GH5353@rama.de.gnumonks.org>
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

Harald Welte wrote:
> On Thu, Aug 11, 2005 at 04:40:32PM +0200, Patrick McHardy wrote:
> 
> 
>>>I think it would be possible to remove the second atomic_inc() and all
>>>the ip_conntrack_put() that immediately follow ulink_expect() - but
>>>would it be worth the effort?  Isn't it an over-optimization that is
>>>likely to cause bugs later on?
>>
>>There is one spot where it isn't possible, in find_expectation
>>the timer reference isn't dropped but returned to the caller.
>>Changing it would either require a special version of unlink_expect
>>or an additional atomic_inc in this function. I don't think its
>>worth the trouble, we do take two references so this seems the
>>cleanest way to me.
> 
> I think I'll add some comment to the code explaining why we need to get
> two references.  

Sure, Yasuyuki and I have asked the same thing in a very short time. So 
this probably will help others.

BTW, I'm still willing to post two patches related with this stuff:

a) kill __ip_ct_expect_unlink_destroy. As Patrick pointed out, it's kind 
of confusing. Actually the only user is conntrack_netlink. So we can 
just export unlink_expect and use it calling ip_conntrack_expect_put 
(already exported).

b) don't increase master conntrack refcount for non-confirmed 
conntracks. It could deadlock. If expectations are killed before the 
master conntrack, we call ip_conntrack_put holding ip_conntrack_lock as 
Yasuyuki described. Actually such thing shouldn't ever happen because 
non-fulfilled(confirmed) expectations are always killed first. Hm, but 
it still looks to me a bit ugly. So I'm proposing to increase the master 
conntrack refcount just once the expectation is fulfilled.

--
Pablo
