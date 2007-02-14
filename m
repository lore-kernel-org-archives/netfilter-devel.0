From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 2.6.20 07/10] nfnetlink_log: fix module
	reference	counting
Date: Wed, 14 Feb 2007 18:07:21 +0100
Message-ID: <20070214170721.GA3065@rere.qmqm.pl>
References: <20070212003956.GH8262@rere.qmqm.pl> <45D1B383.5060400@trash.net>
	<20070213162535.GA10544@rere.qmqm.pl> <45D33CEE.6050404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45D33CEE.6050404@trash.net>
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

On Wed, Feb 14, 2007 at 05:46:38PM +0100, Patrick McHardy wrote:
> Micha³ Miros³aw wrote:
>> On Tue, Feb 13, 2007 at 01:48:03PM +0100, Patrick McHardy wrote:
>>>I think we should just cancel the timer on destruction.
>> It won't solve a race between destroying the instance and logging a
>> packet. It could happen that:
>>[cut]
> This is easily fixable by adding a synchronize_rcu() call
> after removing the instance from the global list.
> nfulnl_log_packet() is called within a RCU read-side
> critical section, so once synchronize_rcu() returns we're
> guaranteed no CPU is within nfulnl_log_packet anymore with
> this instance. And I think it is really preferable to having
> the timer armed after destroying the instance.

That looks better indeed. I'll start on reading what's RCU and
how to use it properly. :)

Thanks,
Michal Miroslaw
