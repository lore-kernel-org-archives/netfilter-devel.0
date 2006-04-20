From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: condition for 2.6.16
Date: Fri, 21 Apr 2006 01:26:09 +0200
Message-ID: <200604210126.11294.max@nucleus.it>
References: <200604201919.19246.max@nucleus.it>
	<200604202139.02931.max@nucleus.it> <44480F94.4010502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44480F94.4010502@trash.net>
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

On Friday 21 April 2006 12:47 am, Patrick McHardy wrote:

> It was discussed at the netfilter workshops, summaries are available at
> workshop.netfilter.org.

I did a cursory check of the site, but I only found a 5 or 6 lines summary for 
every conference. Google doesn't help either.
May you direct me to a more comprehensive report, please?

> You can set up a pomng repository and send us the URL to include in
> the sources.list file once we finish the pomng reorganization.

I'll do it as soon as possible.

> Thats true, mainly because were missing a better kernel-userspace
> interface and better userspace tools. This is also the reason
> why we don't want to include it, its just a workaround for these
> problems.

Are you talking about a grand plan for radically innovative user tools?
Is there anything ready for testing or is it just in the design phase?

Anyway, for the kind of use I have in mind, some global state is needed. Part 
of that state is in the kernel by definition (that's were the rules are), so 
we can enrich that state (condition or something better) or we can maintain a 
second state in userspace and deal with the interactions.

You could say that registering userspace variables is not kernel business, but 
the alternative is just messy (with the tools available in the near future).

If your aim is a minimal set of targets and matches, you could slash many 
other extensions. ROUTE isn't necessary when you can use MARK and iproute2,
but I think it is really convenient. In fact I use ROUTE and condition 
together in some installation with failover connections.

I think I'm missing your goal.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
