From: Robert Hardy <rhardy@webcon.ca>
Subject: Re: Optimizing rule loading, iptables-1.3.0 and iptables-batch
Date: Tue, 7 Sep 2004 21:30:41 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409072117010.11902@vortex.int.webcon.net>
References: <Pine.LNX.4.61.0409070017220.23341@vortex.int.webcon.net>
	<Pine.LNX.4.61.0409071309410.23282@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409071309410.23282@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 7 Sep 2004, Henrik Nordstrom wrote:
> On Tue, 7 Sep 2004, Robert Hardy wrote:
>> iptables-restore still only allows you to save and restore whole tables.
>
> Not entirely true. There is the --noflush (-n) option to iptables-restore 
> which allows you to do any kinds of operations you please.

> Load a user chain:
>
> iptables-restore --noflush << EOF
> *filter
> -F userchain
> -A userchain .....
> COMMIT
> EOF

Ah Good! I obviously missed that somehow....

As a side note for the same ~30000 rules:

Time to load rules via iptables-batch using CIDR syntax: 23 mins 13 secs

Time to load rules via iptables-batch using IPRANGE syntax: 26 mins 36 secs

Time to load rules via iptables-restore (originally using CIDR syntax): 4 mins 25 secs

The time to process the rules set isn't linear with size. In general if you
double a rule set it takes four times longer to load.

At 30000 rules iptables-restore is still 5 times faster than iptables-batch.

Regards,
Rob

-- 
---------------------"Happiness is understanding."----------------------
Robert Hardy, B.Eng Computer Systems                  C.E.O. Webcon Inc.
rhardy <at> webcon <dot> ca    GPG Key available          (613) 276-7327
