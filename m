From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] [PATCH] ctnetlink updates
Date: Wed, 06 Apr 2005 20:08:14 +0200
Message-ID: <4254258E.5000204@eurodev.net>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42502F8D.5030504@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
>> There are some issues I'd like to discuss:
>>
>> o Declaring ID as unsigned int. I think it's just fine.
>>
>>     - A conntrack must be identified with one of the tuples (original 
>> or reply) and its id. That way it can be uniquely identified.
> 
> Good idea, although I'm not completely convinced.

Now I've changed my mind :).

I think that we can identify a connection with both the original and 
reply tuple. Since a connection is represented by means of a conntrack, 
if a user kills a conntrack via ctnetlink, he's willing to kill the 
connection that the conntrack represents, and not to such conntrack itself.

There aren't two conntracks with the same original and reply tuples. I 
can't see anymore why we need such id.

>>     - Using u_int64_t just reduces the possibility of the wrapping 
>> around but such possible problem is still there.
> 
> 
> The time until a wrap is many many years even if you assume very
> high connection rate and many CPUs, so its not a practical problem.
> The difference to your solution is that you can tell for sure that
> clashes won't occur until a date under known conditions. I dislike
> the idea of an unreliable API that has no possibilty of even noticing
> and/or handling the error, so I'm not sure about this.

Yes, you are right this is not a practical problem. Well, if we keep 
using the id, we could detect a wrap and adjust all sequence numbers. Of 
course that this is a expensive operation but it would happen once in a 
blue moon :).

--
Pablo
