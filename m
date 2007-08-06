From: "John Lumby" <johnlumby@hotmail.com>
Subject: Re: Removal of ROUTE target - what now?
Date: Sun, 05 Aug 2007 21:27:57 -0400
Message-ID: <BAY137-F28A4300A178941C885FAB2A3E50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: david@davidcoulson.net, jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

David Coulson wrote:
>
>ip ru add from a.b.c.d table 20
>ip ro add table 20 default via p.q.r.s
>

Thanks - yes, that works (well you knew that but thanks anyway as I didn't).
>
>you can of course use 'ip ru add fwmark 8 table 20' to use a mark from 
>iptables rather than an IP address
>
Didn't try that - seems cleaner to use just the ip routing mechanism.
>
>Make sure you have reverse path filtering disabled on the interface too.
>
Jan Engelhardt wrote:
>
>Since the routing layer now knows about a.b.c.d->p.q.r.s (it does not
>when you use ipt_ROUTE), things could work even if RPF are on.
>Of course that I what I believe or what I believe should be happening;
>if it is not, feel free to correct me
>
>David Coulson wrote:
> >
> > It has been a while since I was running a configuration like that, 
>however I
> > believe that the kernel does not walk every routing table on the system 
>in
> > order to establish RPF state.
> >
> > Might be wrong though - Been a few years.
>
>According to net/ipv4/fib_frontend.c:fib_validate_source(), it builds a 
>flow
>where src/dst and iif/oif are swapped and then does a fib_lookup(), and if
>the devices match, everything is wonderful.
>
>However, now that I look at it - the flow's TOS is set, but not its fwmark.
>Well, routing code is filled with macros and not instantly 'graspable'.
>Maybe one of the maintainers know better.
>
Well, i tested with and without - seems to work in each case.
I had never looked at RPF before but this particular interface comes up with
RPF enabled, and I first disabled it, then established a few conversations  
(SMTP)  which succeeded, then (without dropping the ppp1 IP interface)
echo 1 >/proc/sys/net/ipv4/conf/ppp1/rp_filter
and sent a few more SMTP conversations and they succeeded too.
Don't know if that was a valid test.

Thanks again

John

P.S.   The patch-o-matic extras web page still refers to ipt_ROUTE

_________________________________________________________________
Show Your Messenger Buddies How You Really Feel 
http://www.freemessengeremoticons.ca/?icid=EMENCA122
