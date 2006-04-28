From: Patrick McHardy <kaber@trash.net>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 13:06:45 +0200
Message-ID: <4451F745.4070900@trash.net>
References: <200604201919.19246.max@nucleus.it>
	<200604231547.29009.simonl@parknet.dk> <4451C06D.8000108@trash.net>
	<200604281246.40488.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200604281246.40488.max@nucleus.it>
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
> On Friday 28 April 2006 9:12 am, Patrick McHardy wrote:
> 
> 
>>I'm not really buying that argument, this can all also be done in
>>userspace. But a lot of people seem to consider it useful, so I might
>>reconsider if someone cleans it up so it at least doesn't need to walk
>>the list of conditions for every packet it matches .. but no promises.
> 
> 
> I'll set to work on it. I'll need to change the userspace interface, though.
> The only O(1) way to do it is to store a pointer (or any other id) in the rule 
> itself. I didn't do it in the previous version because I though this was 
> really ugly. I can't find any other match doing a similar thing. Anyway I can 
> do it.

Unfortunately its ugly, but this is a well-known limitation of iptables
itself. Since its the only way to do certain things, I won't complain
if this part is ugly :)

> On the other hand I can make it a guaranteed O(log n) or average O(1) without 
> meddling the rule descriptor and with compatible userspace. What do you 
> prefer?

How would you achieve O(1) average?
