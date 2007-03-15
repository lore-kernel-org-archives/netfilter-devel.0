From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFCT_Q_DUMP problem
Date: Thu, 15 Mar 2007 12:50:31 +0100
Message-ID: <45F93307.10609@netfilter.org>
References: <45F4B34F.3020007@ipom.com>
	<45F527F2.40404@netfilter.org>	<45F6558A.2070601@ipom.com>
	<45F671CA.6010401@netfilter.org>	<45F7A20A.5050302@ipom.com>
	<45F7F5D6.8070904@netfilter.org> <45F81E97.7030903@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F81E97.7030903@ipom.com>
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

Phil Dibowitz wrote:
> Pablo Neira Ayuso wrote:
>> BTW, when do you plan to release your application?
> 
> iptstate(8) is already a released and stable piece of software, but a while
> back Harald Welte had mentioned I should port it from using
> /proc/net/ip_conntrack to "ctnetlink". But at the time ctnetlink was neither
> a stable API nor a friendly API nor was it in any common distros.

Yes, I had a look at this application time ago but I didn't know that 
you were the author. Just some thoughts, it would be fine to measure the 
performance drop that incurs in a busy firewall, even with the ctnetlink 
interface. An alternative can be to fetch information from conntrackd 
[1], it has a statistics mode (still quite simple) so you could fetch 
the conntrack table from the daemon (userspace) instead of the kernel, 
thus not locking the packet processing, even if it's much better as is 
now with ctnetlink than with the /proc interface.

> However libnetfilter_conntrack is in many distros now and is cleaner and
> easier to use, and is a (more?) stable API. So I decided to finally make the
> switch.
> 
> As for when it'll get released... eh... few weeks? The port to the old API
> is done, the port to the new API should be done the next time I have an hour
> or so, and then I have a few new features pending for this release.

Nice, I was about to propose to the coreteam to include a new section in 
the webpage with third party applications that are not directly 
mantained by us, I think that yours can be candidate, my only concern 
here is the current name of your application, I mean, it is not ugly, 
but ipt_state is a match used by iptables and this can get people 
confused. Just to let you know that, in the same direction, I'm going 
merge 'conntrack' [2] and conntrackd into a package called 
conntrack-tools just to avoid this kind of naming problems.

[1] http://people.netfilter.org/pablo/conntrackd/
[2] http://www.netfilter.org/projects/conntrack/index.html

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
