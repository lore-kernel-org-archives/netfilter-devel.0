From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] new 'tcpack' match
Date: Sun, 3 Apr 2005 16:51:41 -0700
Message-ID: <20050403235141.GA28850@linuxace.com>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
	<42507DF8.9030102@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <42507DF8.9030102@outerspace.dyndns.org>
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

On Mon, Apr 04, 2005 at 02:36:24AM +0300, Jonas Berlin wrote:
> | bit more generic. Perhaps a data-len match option.
> 
> I was thinking of this too but couldn't think of much use for more specific
> length-matching, so I thought I'd save a few cycles.. but ok if you think
> it's the way to go, I go. :)
> 
> Any parameter name suggestions? "[!] --has-payload" ?

How bout just a '--datalen [!] X', where X can be any number, including 0?

Phil
