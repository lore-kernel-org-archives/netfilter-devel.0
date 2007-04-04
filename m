From: Ross Vandegrift <ross@kallisti.us>
Subject: Re: iptables match rule for DNS RR?
Date: Wed, 4 Apr 2007 16:39:19 -0400
Message-ID: <20070404203918.GA23386@kallisti.us>
References: <20070404131825.GB20515@kallisti.us>
	<twig.1175694568.67940@bugmachine.ca>
	<20070404135651.GA20727@kallisti.us>
	<Pine.LNX.4.61.0704042212240.22282@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Samuel Jean <jix@bugmachine.ca>, netfilter-devel@lists.netfilter.org,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704042212240.22282@yvahk01.tjqt.qr>
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

On Wed, Apr 04, 2007 at 10:12:38PM +0200, Jan Engelhardt wrote:
> >Wait, I don't want to perform a DNS lookup - rather, I have DNS
> >servers, and I want to be able to filter out DNS requests based on the
> >the types of RRs in the question section.
> 
> ...use l7-filter, and write your pattern.

Heh, didn't know about that, but I've come up with a userspace
ipq program that's working really well.

However I'm getting an occasional netlink error for "No such file or
directory".  It happens every 50-100k requests, I'd guess and doesn't
seem to be affecting the functionality.

What does it mean for netlink to say "no such file or directory"?


-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
