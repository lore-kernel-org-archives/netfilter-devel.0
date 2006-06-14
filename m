From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] ctnetlink events drop benchmark
Date: Wed, 14 Jun 2006 13:38:40 +0200
Message-ID: <448FF540.9050000@netfilter.org>
References: <448ED2DD.30100@netfilter.org>
	<Pine.LNX.4.58.0606140914220.32191@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0606140914220.32191@blackhole.kfki.hu>
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

Hi Jozsef,

Jozsef Kadlecsik wrote:
> On Tue, 13 Jun 2006, Pablo Neira Ayuso wrote:
> 
> 
>>Finally, I've got some results in my test enviroment about the ctnetlink
>>event drop issue. The machine used as firewall is a PIII 866 256 Mbytes
>>RAM, two NIC realtek 8139 100Mbits running debian unstable with linux
>>kernel 2.6.16.
>>
>>I have run the same test with three different socket queue sizes:
>>107.520 (default)
>>215.040 (x2)
>>430.080 (x4)
>>
>>I used netperf to create the connections with a shell script that loops
>>calling netperf -H ip -l 3 &.
> 
> 
> How can you control the connection rate (i.e NEW events) by netperf?

I can't, but I can measure the time required to create N connections

>>To get the number of events dropped I've used the following:
>>
>>$ conntrackd & (run as daemon)
>>$ conntrackd -s (request statistics)
>>
>>Results are available in:
>>
>>http://people.netfilter.org/pablo/ctnetlink/events.eps
> 
> 
> The results are pretty shocking! One would expect (hope) higher event rate
> without event dropping :-(.
> 
> 
>>Currently nlmsg_seq is not set in ctnetlink events, if we set it, we can
>>do some kind of sequence tracking on netlink. If an event gets lost, we
>>can request a resync with the conntrack via dump_conntrack.
> 
> Isn't that overkill? I mean, it'd result even more traffic and thus more
> packet loss.

AFAIK, dumping in done in data chunks of one memory page long. A data 
chunk isn't enqueued until the process calls recv(), therefore a new 
chunk is enqueued iff the process has processed the previous chunk. So, 
dumping really doesn't consumes too much space in the queue but you are 
right, if the dumping happens at the time that the queue is full, then 
the packet will get lost.

>>Another choice could be relax conntrackd states transitions, currently
>>the valid transition sequence is: NEW -> UPDATE -> DESTROY, if an UPDATE
>>event is received but no NEW was seen previously, then the event is
>>ignored. Maybe this is too tight, but since I'm validating the whole
>>thing I prefer remaining "tight" at the moment.
> 
> As I see it does not improve the performance over netlink: the message is
> already received by conntrackd.
> 
> Can we generalize your results and state that (ct)netlink can handle (on
> the given hardvare) max 500-1000 messages/s?

No, the graph doesn't talk about messages/s, just messages: after 
reading your comments, it seems that the graph can be misleading.

Please, have a look at these results in text format:

http://people.netfilter.org/pablo/ctnetlink/107520.txt

I think that it can be better to get some conclusions.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
