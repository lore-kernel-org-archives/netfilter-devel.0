From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables match rule for DNS RR?
Date: Wed, 04 Apr 2007 22:49:01 +0200
Message-ID: <46140F3D.2050605@trash.net>
References: <20070404131825.GB20515@kallisti.us>	<twig.1175694568.67940@bugmachine.ca>	<20070404135651.GA20727@kallisti.us>	<Pine.LNX.4.61.0704042212240.22282@yvahk01.tjqt.qr>
	<20070404203918.GA23386@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Samuel Jean <jix@bugmachine.ca>, netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Ross Vandegrift <ross@kallisti.us>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070404203918.GA23386@kallisti.us>
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

Ross Vandegrift wrote:
> On Wed, Apr 04, 2007 at 10:12:38PM +0200, Jan Engelhardt wrote:
> 
>>>Wait, I don't want to perform a DNS lookup - rather, I have DNS
>>>servers, and I want to be able to filter out DNS requests based on the
>>>the types of RRs in the question section.
>>
>>...use l7-filter, and write your pattern.
> 
> 
> Heh, didn't know about that, but I've come up with a userspace
> ipq program that's working really well.
> 
> However I'm getting an occasional netlink error for "No such file or
> directory".  It happens every 50-100k requests, I'd guess and doesn't
> seem to be affecting the functionality.
> 
> What does it mean for netlink to say "no such file or directory"?


The queue entry you're sending a verdict for does not exist.
