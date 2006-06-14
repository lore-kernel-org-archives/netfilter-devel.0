From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] ctnetlink events drop benchmark
Date: Wed, 14 Jun 2006 14:24:42 +0200
Message-ID: <4490000A.7020500@netfilter.org>
References: <448ED2DD.30100@netfilter.org>
	<Pine.LNX.4.58.0606140914220.32191@blackhole.kfki.hu>
	<Pine.LNX.4.58.0606141002490.32191@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0606141002490.32191@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> On Wed, 14 Jun 2006, Jozsef Kadlecsik wrote:
> 
>>Can we generalize your results and state that (ct)netlink can handle (on
>>the given hardvare) max 500-1000 messages/s?
> 
> Oops, that's false: 500-1000 NEW messages/s. But what is the total number
> of messages/s?

Actually, my concern wasn't really to get the messages/s rate. I started 
the benchmark to know if ctnetlink can back off under big stress 
situation, in other words, if I could experiment messages loss. This is 
really important to validate conntrackd. And it could also be for other 
subsystems like nfqueue.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
