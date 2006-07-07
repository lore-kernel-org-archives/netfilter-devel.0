From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/10] updates for ctnetlink and conntrack core
Date: Fri, 07 Jul 2006 15:46:40 +0200
Message-ID: <44AE65C0.8030209@netfilter.org>
References: <44ADC2EE.905@netfilter.org> <44ADED94.3010703@trash.net>
	<44ADF800.80701@trash.net> <44ADFD1F.7050602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44ADFD1F.7050602@trash.net>
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

Patrick McHardy wrote:
> Patrick McHardy wrote:
> 
>>In some very unscientific tests it showed a difference of about
>>4% when dumping everything compared to only diffs (measured
>>with conntrack accounting enabled). Not something to easily
>>throw away, but I bet we can easily increase the netlink bandwidth
>>for ctnetlink by using more reasonable allocation size and
>>avoiding the netlink_trim call for every single packet..

4% is not too much but it is something, anyway it is true that my 
argument of bandwidth consumption is weak.

But I still like patch 8, if the event cache works fine, I can't see why 
we should force the dumping of all fields. BTW, patch 7 is a new feature 
that I think that we need.

> Some more unscientific tests: saving the netlink_trim call by using
> an allocation size of 200 reduces overhead for the entire notification
> function (including broadcasting) by about 13% (and also reduces
> the overruns experienced by conntrack -E for ~390000 packets with
> 65536 new connections from 17 to 7, which I don't really understand
> since it shouldn't save any netlink bandwidth and this is a SMP system).

Who ever said that benchmarking can be scientific? :) I usually have to 
redo my tests several times. These results are interesting but, in 
previous discussions, I thought that we could not change current 
allocation size because of memory fragmentation issues?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
