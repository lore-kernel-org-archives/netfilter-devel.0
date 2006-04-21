From: "Gerd v. Egidy" <lists@egidy.de>
Subject: Re: condition for 2.6.16
Date: Fri, 21 Apr 2006 02:48:14 +0200
Message-ID: <200604210248.14819.lists@egidy.de>
References: <200604201919.19246.max@nucleus.it> <44480F94.4010502@trash.net>
	<200604210126.11294.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200604210126.11294.max@nucleus.it>
Content-Disposition: inline
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

On Friday 21 April 2006 01:26, Massimiliano Hofer wrote:
> On Friday 21 April 2006 12:47 am, Patrick McHardy wrote:
> > It was discussed at the netfilter workshops, summaries are available at
> > workshop.netfilter.org.
>
> I did a cursory check of the site, but I only found a 5 or 6 lines summary
> for every conference. Google doesn't help either.
> May you direct me to a more comprehensive report, please?

There is no big discussion about condition online but one line at 
http://workshop.netfilter.org/2004/ :

6.2. Decisions about individual patches
...
condition  Stays in POM, because it's ugly and ruleset updates are faster 
these days 

I don't know more than that because I didn't attend that netfilter workshop.

I already had a discussion about the future of condition with Harald back in 
2004 and he basically said the same as Patrick now:

http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/5694

I think something like condition is needed as temporary solution until the 
proposed fast and reliable way to change rules is available. I very much 
appreciate your work on porting it to 2.6, I already had planned doing that 
in the nex two or three month.

Kind regards,

Gerd
