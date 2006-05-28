From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Mon, 29 May 2006 00:53:49 +0200
Message-ID: <447A29FD.20505@netfilter.org>
References: <447A1FB7.5080709@netfilter.org> <447A32FF.9060404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447A32FF.9060404@trash.net>
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
> Pablo Neira Ayuso wrote:
> 
>>I've been working on a pet project during the last months. Part of this
>>stuff is related with my works in the university.
>>
>>The project is called `conntrackd' that is the conntrack userspace daemon.
> 
> Interesting work (and nice featureset), I like the idea of doing this
> in userspace. IIRC Holger Eitzenberger is also working on something
> similar. Do you have performance measurements how this compares to
> ct_sync?

I'll spend tomorrow morning to do that, as soon as I get some results 
I'll post them. Hm, I didn't know that Holger was working on something 
similar, it could be nice if we can join efforts.

>>BTW, I sent a PDF file to netfilter-core but exceeded maximum size a
>>bit, could you accept it? I wrote a small article for USENIX's :LOGIN;
>>about the connection tracking system that will be released in June. I
>>can't release it for public before that date but I sent you a copy in
>>private. Although all that it contains is well known by you ;) but at
>>least have a look at the acknowledgement section.
> 
> I'd be interested, please send it to me in private. Thanks.

Done.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
