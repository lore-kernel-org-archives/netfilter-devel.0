From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ctnetlink questions
Date: Mon, 09 Feb 2004 11:33:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <402761F1.5070402@eurodev.net>
References: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu> <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com> <20040206185242.GM2312@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
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

Hi!

I've been working on an API to add, update conntrack entries since fall 
2003, it's
my final proyect at the university. It's still experimental and it's far 
from Harald and Jozsef
work because of their experience in that matter. Anyway I promise to 
post that patch.

Harald Welte wrote:

>>Because it is not long-term unique. With the tuple approach the
>>administrator risks hitting another connection if the originally intended
>>connection has already been destroyed and replaced by a new connection
>>with the same address details.
>>    
>>

well, I can't see any problem, anyway we could perform some checkings to 
avoid something like this:

- when a create entry message arrives we could check if there's a 
connection with the same address details by using 
ip_conntrack_find_get(...) and if it's found, update the ip_conntrack 
structure with the new info.

but by the means of the id we could have two conntrack structures with 
the same address info. I think that this duplicated info, actually I 
think that it's better considering that last info received about a 
connection is up to date and forget the state of the old one.

>well, but if the tuple is again the same tuple, chances are high the
>administrator actually wants to remove that new connection as much as
>the previous one.  In fact, apart from a short difference in time, they
>_are_ pretty much the same connection.
>  
>
>So from my point of view, the tuple is still sufficient.  Tuple can be
>used by userspace to identify a connection, tuple is used for
>replication messages in ct_sync.
>
>We can also guarantee, that all entries that
>	- existed before the dump started
>	- and still exist when the dump ended
>are actually dumped.
>
>We don't make any guarantees about connections that either started
>within that timeframe, or have been terminated within that timeframe.
>
>I would really like to see the ordered list and id disappear.
>  
>
I agree with Harald, actually I think that adding a new id and that 
ordered stuff will complicate
the current structure, I would prefer redesigning the current structure 
of the conntrack table than adding those fields.

best regards,
Pablo
