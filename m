From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: [PATCH] Very first try: ipt_connrate patch.
Date: Mon, 16 Feb 2004 18:19:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <874qtr9ev6.fsf@iki.fi>
References: <87bro9fiqq.fsf@iki.fi> <4030A6F8.5030606@trash.net>
 <878yj39p9a.fsf@iki.fi> <4030C0A9.2090003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> There are patches for per-bucket locking in pom, look at
> extra/conntrack_locking.patch if you are interested.

Ah. Okay, I'll settle for "it's in the works".

> That should do it for now. I wouldn't expect any performance
> problems as the critical section is really short.

Agreed.

-- Naked
