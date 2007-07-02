From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [PATCH] add TCP protocol state event groups
Date: Mon, 02 Jul 2007 11:40:54 +0200
Message-ID: <4688C826.4020404@astaro.com>
References: <466D8EEB.9080601@netfilter.org> <4677DB3F.8010901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4677DB3F.8010901@trash.net>
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

>> This patch adds per-protocol state event groups, so one can only listen to a 
>> certain TCP state change such as ESTABLISHED. Although such per-state message
>> filtering could be done in userspace, we save CPU cycles since the kernel does
>> not need to build and delivery messages that will be later discarded in 
>> userspace. This patch is particularly useful for conntrackd.

> I can see that this is useful, but one group per protocol state
> sounds rather excessive, I would expect that we could group them
> more logically, maybe "connection setup, teardown and updates"?
> Which states is conntrackd particulary interested in?

> I would also like to hear from Holger whether his conntrack daemon
> could make use of a mechnism like this too and if the filtering
> capabilities you propose will do.

Hi :)

Sorry for my late answer, but I am currently rather busy with other stuff.

ctsyncd currently does quite some per-protocol filtering, e.g. TCP 
connections currently get synced only after being in the ESTABLISHED 
state and deleted on the slave side if the teardown event is received. 
This greatly reduces the number of events which are send to the ctsyncd 
peer.

Although ctsyncd does not have a performance problem at all even if I 
run it against our Spirent performance system I generally like the idea 
of doing some of the filtering in kernelspace.  Though I would leave the 
userspace filtering code as a fallback solution in place.

As of July I have a new colleague which hopefully takes over some of the 
workloads I currently have.  My plan therefore for ctsyncd is to finally
improve filtering capability of ctsyncd and make if configurable, as 
currently most of the filtering code is still hardcoded.  My plan is 
also to improve the partnership with keepalived et all, basically making 
this part more configurable too.  This version will then be my 1.0 
release, as it currently runs fine for serveral months now on our ASG 
products.

So hopefully I am able to release ctsyncd 1.0 into the public within the 
next few weeks, especially with Netfilter Workshop in mind.

Hope that helps.

   /holger


-- 
Holger Eitzenberger <heitzenberger@astaro.com> | Kernel Developer
Astaro AG | www.astaro.com | Phone +49-721-25516-246 | Fax -200

Download your free 30 day trial version of the award-winning Astaro
Security Gateway solution here: https://my.astaro.com/download/
