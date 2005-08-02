From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 6/7] Fix expectation creation
Date: Tue, 02 Aug 2005 13:31:28 +0200
Message-ID: <42EF5990.7010900@eurodev.net>
References: <42EE56AD.40505@eurodev.net>
	<20050802074556.GB4158@rama.de.gnumonks.org>
	<20050802094722.GF4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050802094722.GF4158@rama.de.gnumonks.org>
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

Harald Welte wrote:
> On Tue, Aug 02, 2005 at 09:45:56AM +0200, Harald Welte wrote:
> 
>>On Mon, Aug 01, 2005 at 07:06:53PM +0200, Pablo Neira wrote:
>>
>>>Expectation creation is broken, now it works again.
>>
>>well, you also make it a nested attribute now.  I'm not sure whether
>>this is the way to go.  And if you do, there are certainly some CTA
>>values from nfnetlink_conntrack.h that need to be removed with the same
>>patch.
> 
> Mh. I'm still somewhat undecided on this issue.  We don't encapsulate
> 'struct ip_conntrack' in one nested attribute, but with your patch we do
> it for 'struct ip_conntrack_expect'.  This sounds a bit inconsistent to
> me.

We could move CTA_EXPECT_[TUPLE|MASK] to ctattr_type, kill 
CTA_EXPECT_[ID|TIMEOUT] and use CTA_[ID|TIMEOUT] but then we'll be in 
trouble. See that during expectation creation we send the information 
related with master conntrack and the expectation. We need a way to 
separate what information is related with the conntrack, and what is 
related with the expectation. Nesting a conntrack inside something like 
CTA_CONNTRACK is too much I think.

See that an expectation doesn't have any meaning by itself without a 
conntrack. That's why I decided to keep it as a nested attributes inside 
a conntrack. Because of the implicit relationship that links them.

> Independent of this discussion, could you please submit two patches:
> 1) one that just fixes the bug(s) that you currently see with expect_create
 > 2) one patch incremental to '1)' that adds nesting of expectations.

Sorry, I don't understand how I can do this yet. I see that 1) and 2) 
can't be split since the bug is that (based on the current structure of 
conntrack netlink attributes), we need to parse CTA_EXPECT nested 
attributes and we aren't doing it.

--
Pablo
