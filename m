From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables match rule for DNS RR?
Date: Wed, 4 Apr 2007 22:12:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704042212240.22282@yvahk01.tjqt.qr>
References: <20070404131825.GB20515@kallisti.us>
	<twig.1175694568.67940@bugmachine.ca>
	<20070404135651.GA20727@kallisti.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Samuel Jean <jix@bugmachine.ca>, netfilter-devel@lists.netfilter.org,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Ross Vandegrift <ross@kallisti.us>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070404135651.GA20727@kallisti.us>
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


On Apr 4 2007 09:56, Ross Vandegrift wrote:
>On Wed, Apr 04, 2007 at 01:49:28PM -0000, Samuel Jean wrote:
>> On Wed, Apr 4, 2007, Ross Vandegrift <ross@kallisti.us> said:
>> > Is there any netfilter work, either production or in development, that
>> > provides a way to filter traffic based on DNS RR type?
>> 
>> Sorry -- matching packets based on RR is not possible inside the kernel.
>> Netfilter needs to make a decision pretty fast and cannot wait for DNS
>> queries
>> each time a packet passes by. IMO, this makes huge sense.
>
>Wait, I don't want to perform a DNS lookup - rather, I have DNS
>servers, and I want to be able to filter out DNS requests based on the
>the types of RRs in the question section.

...use l7-filter, and write your pattern.


Jan
-- 
