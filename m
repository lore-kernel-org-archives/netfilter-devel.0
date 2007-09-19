From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFT] Improve iptables error reporting
Date: Wed, 19 Sep 2007 14:56:49 +0200
Message-ID: <46F11C91.3000509@trash.net>
References: <Pine.LNX.4.62.0708120038080.28796@wlug.westbo.se>
	<Pine.LNX.4.62.0709111037250.17234@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.62.0709111037250.17234@wlug.westbo.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:
> On Sun, 12 Aug 2007, Martin Josefsson wrote:
> 
>> Here's a small patch that reworks the iptables/ip6tables error
>> reporting a bit. The purpose of this patch is to try to provide more
>> resonable error messages.
> 
> 
> [snip]
> 
>> Please test and report success or failure. I'm likely to have missed
>> some/many errors.
> 
> 
> No takers on this?


I'm testing it locally. So far nicer error messages, no problems.

> Maybe we should merge it to make people test it? :)


I think thats a good idea, we need a few -rcs for the next release
anyway.

BTW, Pablo, any plans for the rc-release?
