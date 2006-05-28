From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_nat_sip: fix compiler warning
Date: Sun, 28 May 2006 17:34:46 +0200
Message-ID: <4479C316.7070406@trash.net>
References: <1148823979.32002.2.camel@scaramouche.combox.de>	
	<4479B3C4.1040404@trash.net>
	<1148830346.32002.9.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148830346.32002.9.camel@scaramouche.combox.de>
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

Torsten Luettgert wrote:
> BTW: What about the new protoff argument to match functions, and
> the change from struct ipt_ip * to void * in the checkentry
> functions (e.g. in the set match).
> 
> Are those already fixed and going upstream, too, or would it be
> worthwile to submit patches for old matches and targets?

I guess anything still in pom is worth fixing. There are
a couple of patchlets that have found new maintainers but
don't have an external repository yet, those will be
removed once those repositories are set up. Until then
I have no problems applying fixes to them.
