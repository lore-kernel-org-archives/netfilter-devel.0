From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Tue, 10 Feb 2004 13:39:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4028D0E5.8000003@trash.net>
References: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu> <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com> <20040206185242.GM2312@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040206185242.GM2312@obroa-skai.de.gnumonks.org>
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
> On Mon, Oct 20, 2003 at 11:29:46AM +0200, Henrik Nordstrom wrote:
>>Because it is not long-term unique. With the tuple approach the
>>administrator risks hitting another connection if the originally intended
>>connection has already been destroyed and replaced by a new connection
>>with the same address details.
> 
> 
> well, but if the tuple is again the same tuple, chances are high the
> administrator actually wants to remove that new connection as much as
> the previous one.  In fact, apart from a short difference in time, they
> _are_ pretty much the same connection.
> 
> So from my point of view, the tuple is still sufficient.  Tuple can be
> used by userspace to identify a connection, tuple is used for
> replication messages in ct_sync.
> 
> We can also guarantee, that all entries that
> 	- existed before the dump started
> 	- and still exist when the dump ended
> are actually dumped.
> 
> We don't make any guarantees about connections that either started
> within that timeframe, or have been terminated within that timeframe.
> 
> I would really like to see the ordered list and id disappear.

I can make my peace with not having a unique identity for each conntrack
over time, but the other use for IDs was to continue an interrupted
dump at the right place, how can we solve this ? The problematic case
is when a single hash-chain doesn't fit into an skb. We need to remember
the last one dumped somehow, and be able to continue at the next one
not dumped even when the last one dumped is gone when the dump
continues.

Best regards,
Patrick
