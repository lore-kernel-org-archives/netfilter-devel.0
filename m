From: Patrick McHardy <kaber@trash.net>
Subject: Re: Follow packets in rules
Date: Wed, 13 Jun 2007 18:53:10 +0200
Message-ID: <467020F6.2050906@trash.net>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Fabrice Rafart <fabrice.rafart@efs.sante.fr>,
	netfilter-devel@lists.netfilter.org, nicboul@gmail.com,
	pablo@netfilter.org, =?ISO-8859-15?Q?Juan_Le=F3n?= <debjuanca@gmail.com>
To: jix@bugmachine.ca
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <twig.1181752139.4605@bugmachine.ca>
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

Samuel Jean wrote:
> There was the TRACE target born for this purpose a couple years ago.
> 
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/branches/patch-o-matic-ng/linux-2.6.11/TRACE/?rev=3680
> 
> It sure will require a bit of hacking for recent kernels.
> 
> Pablo, Patrick --
> 
> Is this an interesting feature that worths merging in mainline, or
> patch-o-matic at least ?


It would be interesting for the kernel if it can be done in a
non-intrusive way. I can't remember what the old patches exactly
did, but I believe it was kind of a hack.
