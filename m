From: Johannes Graumann <graumann@caltech.edu>
Subject: Re: patch-o-matic-ng questions and remarks from newbie
Date: Mon, 15 Nov 2004 14:13:26 -0800
Message-ID: <20041115141326.4ced89bc@localhost>
References: <20041107102832.463003a4@localhost>
	<418E8EB7.8050604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <418E8EB7.8050604@trash.net>
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

Thanks,

I found those and have finally managed to get my kernel to compile.
One general question of mine remains unsolved: is there - aside from
trial and error - some way to figure out which patch in the
patch-o-matic-ng plays well with what kernel?

Thanks, Joh

On Sun, 07 Nov 2004 22:08:07 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Johannes Graumann wrote:
> 
> >I'm reposting this in the devel mailing list in the hope to find more
> >of an echo than in the 'normal' one ...
> >
> >Hello,
> >
> >In order to use my shorewall/2.6 based firewall to route IPSECed
> >(openswan) wireless, I need to apply these patches from the
> >patch-o-matic-ng (extra):
> >1) ipsec-01-output-hooks
> >2) ipsec-02-input-hooks
> >3) ipsec-03-policy-lookup
> >4) ipsec-04-policy-checks
> >5) policy
> >
> >It took me a whole night to figure out that these are only cleanly
> >applicable to a 2.6.6 kernel and nothing later - which is ok with me
> >... if I only would have managed to find this information without
> >loading down 2.6.9, 2.6.8, 2.6.7 and 2.6.6 source and testing the
> >patch-o-matic with every single one of these! Can somebody please
> >help me dummy in finding this information? Are these patches expected
> >to get a revamp to be capable to cope with 2.6.9?
> >  
> >
> Someone recently posted patches for 2.6.9 to this list, please
> search the archives.
> 
> >On another note: are/when are these features scheduled to go into the
> >2.6 series?
> >
> Very soon hopefully. I'll post my patches for 2.6.10 for discussion
> in a couple of days.
> 
> Regards
> Patrick
> 
> 
> 
