From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Very first try: ipt_connrate patch.
Date: Mon, 16 Feb 2004 14:07:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4030C0A9.2090003@trash.net>
References: <87bro9fiqq.fsf@iki.fi> <4030A6F8.5030606@trash.net> <878yj39p9a.fsf@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nuutti Kotivuori <naked@iki.fi>
In-Reply-To: <878yj39p9a.fsf@iki.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Nuutti Kotivuori wrote:
> Right. I didn't see any locking in resolve_normal_ct, so I assumed no
> locking was needed. Then I peeked in the functions it calls and every
> one of them gets the ip_conntrack_lock.
> 
> But, I am a bit confused on the best way to handle locking. For
> example, ip_conntrack_proto_tcp has only one RWLOCK which it uses. I
> can undestand this for the actual connection tracking table, but for
> the subentries in it... well, why would writing to one conntrack
> element block reading from another conntrack element - or simultaneous
> writing to two different conntrack elements and so on. Shouldn't there
> be some locking per connection tracking entry, so other entries could
> simultaneously be processed on other processors?

There are patches for per-bucket locking in pom, look at
extra/conntrack_locking.patch if you are interested.

> SMP performance and correctness is an important issue for me, as I am
> specifically running this on an SMP machine. Luckily I haven't ran
> into any problems yet - thanks for spotting this. I shall implement
> things as proto_tcp does it for now.

That should do it for now. I wouldn't expect any performance problems
as the critical section is really short.

Regards,
Patrick


> 
> -- Naked
> 
> 
