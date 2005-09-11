From: Patrick McHardy <kaber@trash.net>
Subject: Re: MASQUERADE + DHCP problem
Date: Mon, 12 Sep 2005 01:57:22 +0200
Message-ID: <4324C462.9040804@trash.net>
References: <43244826.5020405@trash.net>
	<1126481675.9832.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1126481675.9832.3.camel@localhost.localdomain>
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

Rusty Russell wrote:
> On Sun, 2005-09-11 at 17:07 +0200, Patrick McHardy wrote:
> 
>>2) Add a special hack to masquerade to handle DHCP while no
>>   local address exists by looking at the port and src/dst
>>   address. Incredibly ugly and wrong :)
> 
> 
> If IP src is 0.0.0.0, let it through untouched.  Those packets are
> presumably not supposed to be masqueraded, so it's the Right Think
> AFAICT.
> 
> Will that fix DHCP?

Absolutely. Since these packets never get routed, the only possibility
when they can occur is when a local raw socket with IP_HDRINCL chooses
a source address of 0. In that case it definitely seems right to leave
the packet alone.

Thanks!

Patrick
