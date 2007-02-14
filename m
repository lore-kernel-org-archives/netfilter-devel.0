From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 07/10] nfnetlink_log: fix
	module	reference	counting
Date: Wed, 14 Feb 2007 18:22:12 +0100
Message-ID: <45D34544.5090802@trash.net>
References: <20070212003956.GH8262@rere.qmqm.pl>
	<45D1B383.5060400@trash.net>	<20070213162535.GA10544@rere.qmqm.pl>
	<45D33CEE.6050404@trash.net> <20070214170721.GA3065@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: mirq-linux@rere.qmqm.pl
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070214170721.GA3065@rere.qmqm.pl>
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

Micha=B3 Miros=B3aw wrote:
> On Wed, Feb 14, 2007 at 05:46:38PM +0100, Patrick McHardy wrote:
>=20
>>Micha=B3 Miros=B3aw wrote:
>>
>>>On Tue, Feb 13, 2007 at 01:48:03PM +0100, Patrick McHardy wrote:
>>>
>>>>I think we should just cancel the timer on destruction.
>>>
>>>It won't solve a race between destroying the instance and logging a
>>>packet. It could happen that:
>>>[cut]
>>
>>This is easily fixable by adding a synchronize_rcu() call
>>after removing the instance from the global list.
>>nfulnl_log_packet() is called within a RCU read-side
>>critical section, so once synchronize_rcu() returns we're
>>guaranteed no CPU is within nfulnl_log_packet anymore with
>>this instance. And I think it is really preferable to having
>>the timer armed after destroying the instance.
>=20
>=20
> That looks better indeed. I'll start on reading what's RCU and
> how to use it properly. :)

Unfortunately the patch is still broken, we might hold
instances_lock and thus may not sleep (and especially
not call synchronize_rcu() since it will never return).
I'll look into this again, probably the conditional
locking should be removed as a first step.
