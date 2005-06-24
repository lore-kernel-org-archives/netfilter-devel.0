From: Corey Giovanella <coreygiovanella@challenge-engineering.com>
Subject: Re: New target to control a fake network interface
Date: Fri, 24 Jun 2005 04:12:01 +0000
Message-ID: <1119586321.8230.80.camel@envy>
References: <1119319953.4109.59.camel@envy>
	<8C06C084907746238C329ABC@[10.0.0.14]>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kenneth Porter <shiva@sewingwitch.com>
In-Reply-To: <8C06C084907746238C329ABC@[10.0.0.14]>
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

> You're echoing iptables packet counts into a fake interface to make it 
> available to an existing graphical monitor application. The app has a 
> plugin system, so wouldn't it be better to write an iptables plugin for it? 

Yes, you are quite possibly right.  If my only concern was gkreallm a
plugging would probably have been better.  One reason I did it this way
was to do some kernel level programing, and to play around with
iptables.  Also, this seems like a much more general solution that could
be used for other things and in other apps if someone wanted to.  for
example, it works with ifconfig.

> What's the advantage of copying the counters to another kernel object?

I'm not sure if you are asking why I wrote this as two modules or
something else.  I'm pretty sure I could have made it all into one
kernel module.  At the time I just thought that would have made life a
bit more difficult and complicated to make it one module.

> The fake interface is an interesting object but maybe not the best solution 
> for this particular problem.

I agree, it's probably not the best if the problem was just with
gkrellm.  A gkrellm plugin would have been much better.  I went the way
I did for the reasons mentioned above.

> Given a general iptables plugin, this would make a good replacement for 
> ntop as a packet-counting protocol analyzer. I find ntop (which uses 
> libpcap) a bit "heavyweight" for just counting packets, as it also does 
> deep analysis of their content and hence uses a fair amount of memory and 
> CPU. (ntop also exposes the data via web interface, which is nice for 
> non-Linux clients.)

Thank you for the feedback.
-- 
Corey Giovanella <coreygiovanella@challenge-engineering.com>
www.challenge-engineering.com/~corey/
