From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] new 'tcpack' match
Date: Sun, 3 Apr 2005 17:52:42 -0700
Message-ID: <20050404005242.GA29087@linuxace.com>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
	<42507DF8.9030102@outerspace.dyndns.org>
	<20050403235141.GA28850@linuxace.com>
	<4250852B.2010802@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <4250852B.2010802@outerspace.dyndns.org>
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

On Mon, Apr 04, 2005 at 03:07:07AM +0300, Jonas Berlin wrote:
> Yeah, datalen perhaps.. but should it maybe also match a range instead of
> just one exact length?

Sure, and maybe both ranges and multiple lengths, similar to how revision 1
of the multiport match handles ports.  So:

	--datalen [!] A[,B:C[,D]]

Phil
