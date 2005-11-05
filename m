From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] add missing module_alias_subsys
Date: Sat, 05 Nov 2005 12:56:06 +0100
Message-ID: <436C9DD6.8090101@trash.net>
References: <436BA1C1.8070806@netfilter.org> <436C5FBC.70804@trash.net>
	<20051105115337.GB16000@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051105115337.GB16000@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Sat, Nov 05, 2005 at 08:31:08AM +0100, Patrick McHardy wrote:
> 
>>Pablo Neira wrote:
>>
>>>Add missing module alias. This is a must to load ctnetlink on demand.
>>>For example, the conntrack tool will fail if the module isn't loaded.
>>
>>I don't think this is a good idea currently. Capability checking is
>>done after module autoloading, so any user can load ctnetlink,
>>ip_conntrack and all related modules. 
> 
> interesting point, thanks for mentioning it.
> 
> 
>>Please make sure to move capability checking in nfnetlink before
>>module loading first.
> 
> 
> This unfortunately doesn't work with the current architecture, where
> every nfnetlink subsystem can specifiy the required capabilities per
> message.  That specification isn't available before loading the module,
> though.

Didn't we decide to remove the per-subsys capabilities and make all
of them require CAP_NET_ADMIN?

> I think we can (in addition to our usual capability checks) add a
> capability check to only do autoloading of a module if CAP_NET_ADMIN is
> set.  Like:

That also a possiblity, but I can't think of a case where we wouldn't
insist on CAP_NET_ADMIN, so just removing the whole per-subsys
capabilities seems easier to me.
