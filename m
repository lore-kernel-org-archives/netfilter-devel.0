From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RESEND][PATCH] Recent match jiffies wrap mismatches
Date: Wed, 30 Nov 2005 00:03:42 +0100
Message-ID: <438CDE4E.8070006@trash.net>
References: <20051129050813.GA30630@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20051129050813.GA30630@linuxace.com>
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

Phil Oester wrote:
> Around jiffies wrap time (i.e. within first 5 mins after boot), recent match
> rules which contain both --seconds and --hitcount arguments experience
> false matches.
> 
> This is because the last_pkts array is filled with zeros on creation, and
> when comparing 'now' to 0 (+ --seconds argument), time_before_eq thinks it
> has found a hit.
> 
> Below patch adds a break if the packet value is zero.  This has the unfortunate
> side effect of causing mismatches if a packet was received when jiffies really
> was equal to zero.  The odds of that happening are slim compared to the
> problems caused by not adding the break however.  Plus, the author used
> this same method just below, so it is "good enough".

Applied, thanks. The lines just above that have the same problem, don't
they?

[slightly reformated for better readability]

if(info->seconds && !info->hit_count) {
     if(time_before_eq(now,r_list[location].last_seen+info->seconds*HZ))
         ans = !info->invert;
     else
         ans = info->invert;
}
