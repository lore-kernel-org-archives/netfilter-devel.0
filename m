From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Set mark to 0 from libnetfilter_conntrack
Date: Fri, 27 Oct 2006 15:53:31 +0200
Message-ID: <45420F5B.8090504@netfilter.org>
References: <1161801498.12718.22.camel@localhost>	 <453FF539.3020107@trash.net>
	<1161898638.7358.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, vincent@inl.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1161898638.7358.22.camel@localhost.localdomain>
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

Eric Leblond wrote:
> Hello,
> 
> Le jeudi 26 octobre 2006 à 01:37 +0200, Patrick McHardy a écrit :
>> The idea is still the right one, I think the library
>> should take care of adding a CTA_MARK attribute without any user bitmask
>> fiddling by including it if the value differs from the mark contained in
>> the received conntrack. I think Pablo's new API will allow this.
> 
> What's the status of this new API ? Current status of
> libnetfilter_conntrack code is really disappointing.

Indeed, you can blame me for that. I'm working on the new API that I'll 
try to release asap. I'm going to put this in my high priority queue.

> We at INL are currently working on using libnetfilter_conntrack to
> provide tools for firewall administrators. The first one
> pynetfilter_conntrack is already available and a web management
> interface will soon be released. By doing this we are trying to improve
> the usability of this new system.

I'd like to see your python binding in the libnetfilter_conntrack tree 
but I have to fix some stuff before, please consider that this would 
require some extra work from your part.

> We are doing this because we think the new features provided by
> libnetfilter_conntrack really improve a lot the way we use and "live"
> with a Netfilter firewall.
> 
> Sadly, the uncertainty on code evolution and the lack of frequent
> releases are wounding the expansion of these ideas.

We are working to improve the release process, expect changes soon.

> From my point of view, a decision on libnetfilter_conntrack
> developpement should be made quickly :
>       * Should pablo's version become the next step in this branch ? or
>       * Is it necessary to create a new branch to keep a stable version
>         and have compatibility with the few existing applications ?

I already commented what my intentions are: add more new API, do not 
remove the old one but mark it as deprecated, strongly recommend people 
to move to the new API. The deprecated API will be removed after quite 
some time.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
