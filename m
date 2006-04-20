From: Patrick McHardy <kaber@trash.net>
Subject: Re: condition for 2.6.16
Date: Fri, 21 Apr 2006 00:47:48 +0200
Message-ID: <44480F94.4010502@trash.net>
References: <200604201919.19246.max@nucleus.it> <4447D7AA.1010602@trash.net>
	<200604202139.02931.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200604202139.02931.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Thursday 20 April 2006 8:49 pm, Patrick McHardy wrote:
> 
>>We have already decided that the condition match will not be merged
>>because the same thing can easily be done by adding/removing rules
>>from userspace.
> 
> 
> Sorry, I missed that discussion.

It was discussed at the netfilter workshops, summaries are available at
workshop.netfilter.org.

> Is it still possible to include it in the external patches?

You can set up a pomng repository and send us the URL to include in
the sources.list file once we finish the pomng reorganization.

> Anyway I think condition allows for a much more elegant solution in cases 
> where adding and removing rules would lead to a messy and unpredictable 
> sequence of overlapping rules, not to mention races between different 
> modifications.
> Just my humble opinion.


Thats true, mainly because were missing a better kernel-userspace
interface and better userspace tools. This is also the reason
why we don't want to include it, its just a workaround for these
problems.
