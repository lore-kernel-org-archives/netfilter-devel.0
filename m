From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Very first try: ipt_connrate patch.
Date: Mon, 16 Feb 2004 12:18:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4030A6F8.5030606@trash.net>
References: <87bro9fiqq.fsf@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nuutti Kotivuori <naked@iki.fi>
In-Reply-To: <87bro9fiqq.fsf@iki.fi>
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
> I would be glad to get as many comments about it as early as
> possible, also on the usefulness of what I'm doing here.

> +void
> +ip_conntrack_rate_count(struct ip_conntrack_rate *ctr,
> +			unsigned int len)
> +{
> +	u_int32_t new_bytes;
> +	unsigned long now = jiffies;
> +
> +	new_bytes = (ctr->avgrate * IP_CONNTRACK_RATE_INTERVAL +
> +		     len * IP_CONNTRACK_RATE_SCALE);
> +	if(new_bytes > MAX_TOKENS_IN_WINDOW)
> +		new_bytes = MAX_TOKENS_IN_WINDOW;
> +	ctr->avgrate = new_bytes / (now - xchg(&ctr->prev, now) +
> +				    IP_CONNTRACK_RATE_INTERVAL);
> +}

You need locking here. Other CPUs can change ctr->avgrate between
reading and updating it. The xchg operation becomes unneccessary
with proper locking.

Regards,
Patrick
