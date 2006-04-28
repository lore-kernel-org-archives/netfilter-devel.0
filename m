From: Patrick McHardy <kaber@trash.net>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 09:12:45 +0200
Message-ID: <4451C06D.8000108@trash.net>
References: <200604201919.19246.max@nucleus.it> <4447D7AA.1010602@trash.net>
	<200604231547.29009.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <200604231547.29009.simonl@parknet.dk>
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

Simon Lodal wrote:
> On Thursday 20 April 2006 20:49, Patrick McHardy wrote:
> 
> 
>>We have already decided that the condition match will not be merged
>>because the same thing can easily be done by adding/removing rules
>>from userspace.
> 
> 
> Conditions enable role separation between us admins.
> 
> No matter how good or fast the userspace tools are, there are cases where you 
> simply do not want to (let others) run them, but it is acceptable to (let 
> others) turn on/off some predefined blocks of rules.
> 
> Plus it is faster, less risky, and does not reset counters.

I'm not really buying that argument, this can all also be done in
userspace. But a lot of people seem to consider it useful, so I might
reconsider if someone cleans it up so it at least doesn't need to walk
the list of conditions for every packet it matches .. but no promises.
