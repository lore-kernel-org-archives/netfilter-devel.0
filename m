From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Get icmp ratelimit from sysctl in ipt_REJECT.c
Date: Wed, 09 Feb 2005 00:34:37 +0100
Message-ID: <42094C8D.1030009@trash.net>
References: <20050208042943.7284.qmail@web60602.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Duncan Palmer <dunk_palmer@yahoo.com>
In-Reply-To: <20050208042943.7284.qmail@web60602.mail.yahoo.com>
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

Duncan Palmer wrote:

>Hi,
>
>Whilst working on a netfilter module, I noticed a
>comment in ipt_REJECT.c saying 'FIXME: Use sysctl
>number. --RR' before a call to xrlim_allow(). This is
>fixed in the attached patch (against 2.6.11-rc2-mm1,
>but applies cleanly to rc3-mm1 as well).
>
I was never convinced of using xrlim_allow in ipt_REJECT. We
already have the limit match, which allows to set limits in
the ruleset. The current of of xrlim_allow is actually broken,
the max number of tokens in the dst_entry is limited by the timeout
value, so both icmp.c and ipt_REJECT.c are limited by the smaller
of both timeouts when ICMPs are sent by both. ipt_REJECT also
doesn't care about icmp_ratemask and uses up token for types
that shouldn't be limited. So we can either remove it entirely
or use icmpv4_xrlim_allow. If there are no objections I would
prefer to remove it.

Regards
Patrick
