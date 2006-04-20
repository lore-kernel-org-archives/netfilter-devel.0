From: Patrick McHardy <kaber@trash.net>
Subject: Re: condition for 2.6.16
Date: Thu, 20 Apr 2006 20:49:14 +0200
Message-ID: <4447D7AA.1010602@trash.net>
References: <200604201919.19246.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200604201919.19246.max@nucleus.it>
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
> I find this extension very useful, so I did a complete porting to 2.6.16 
> complete with XT. I fixed various things (mostly fossils of the 2.4 era) in 
> the process and it works in my test environment.
> I am about to test it in a few high load machines, but I'd appreciate if 
> someone else could have a look at it.
> 
> What are the next steps in order to have it included in the core extension and 
> finally merged in the kernel?

We have already decided that the condition match will not be merged
because the same thing can easily be done by adding/removing rules
from userspace.
