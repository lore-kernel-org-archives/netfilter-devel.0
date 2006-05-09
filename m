From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: Libnetfilter_conntrack problems
Date: Tue, 09 May 2006 17:12:14 +0200
Message-ID: <4460B14E.90506@eurodev.net>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>	<20060501175353.GD5267@rama>	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>	<20060503111549.GO16562@sunbeam.de.gnumonks.org>
	<ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-1?Q?S=E9bastien_LAVEZE?= <slaveze@gmail.com>
In-Reply-To: <ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>
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

Hi,

Sébastien LAVEZE wrote:
>> > However the DESTROY events come a long time after the actual end of a
>> > connection by timeout...am I right ?
>>
>> not really.  please be more specific.  what is 'end of a connection by
>> timeout'? which specific timeout of which particular state are you
>> talking about?
> 
> 
> My problem is pretty strange...
> I got two processes, one has a callback registered to UPDATE events,
> the other one has a callback registered to DESTROY event
> 
> I do get destroy events but not all the time, when i have tcp
> connections that go from ESTABLISHED state to FIN_WAIT and finally to
> TIME_WAIT ( i see the progression of these states with the process
> linked to  UPDATE events ) But when the TIME_WAIT timer is over i do
> not get the DESTROY event...

Could you try to do the same thing with the conntrack tool and let us 
know if the problem still persists?

to catch update events
# conntrack -E -e UPDATE

to catch destroy events
# conntrack -E -e DESTROY

-- 
Pablo
