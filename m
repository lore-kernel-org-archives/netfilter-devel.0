From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: NAT configuration over ctnetlink
Date: Thu, 11 May 2006 09:05:53 +0200
Message-ID: <4462E251.40908@trash.net>
References: <4451BA40.4050207@trash.net> <445388B9.2010308@netfilter.org>
	<4457677D.7060607@trash.net> <44578E0C.5070705@netfilter.org>
	<4457926D.5010209@trash.net> <4457EBF9.3080606@netfilter.org>
	<4458B2BB.8000407@trash.net>
	<20060510191646.GB29531@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060510191646.GB29531@sunbeam.de.gnumonks.org>
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
> On Wed, May 03, 2006 at 03:40:11PM +0200, Patrick McHardy wrote:
> 
> 
>>Another item I would like to bring up for discussion is whether we
>>want to continue with (some) of these libraries at all. For a small
>>pet-project of mine I've been working a bit on Thomas Graf's libnl,
>>which provides a very nice netlink infrastructure, support for
>>basically all kernel netlink interfaces, nice object representation
>>of the individual items, cache management for replication of kernel
>>databases, and quite a few things more. Besides lots of nice
>>infrastructure, one main advantage of using libnl would be that
>>there is a single library which can be used for communication with
>>any kernel subsystem using netlink in a uniform way.
> 
> 
> well, certainly that work is interesting.  However, I don't really see
> how this fits into the picture.  First of all, nfnetlink is different in
> that it has its peculiar byteorder.


Unfortunately that is true, but it shouldn't be that hard to adapt
libnl. But you're certainly right that this needs to be looked into
before reasonably continuing this discussion.


  Also, we specifically divided the
> libraries into separate packages so they can be updated independently.
> It is unlikely that conntrack bugfixes affect logging and vice versa.


I don't see that as a problem, what does it matter whether I need
to update one library dealing with logging or another library dealing
with everything .. given that it is a pure bugfix update. Using that
library would IMO not only give us lots of nice features (at least
parts of which we would need to duplicate otherwise), but also benefit
users by providing uniform access to the kernel.
