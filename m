From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: New target to control a fake network interface
Date: Wed, 22 Jun 2005 06:18:04 -0700
Message-ID: <8C06C084907746238C329ABC@[10.0.0.14]>
References: <1119319953.4109.59.camel@envy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1119319953.4109.59.camel@envy>
Content-Disposition: inline
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

--On Tuesday, June 21, 2005 2:12 AM +0000 Corey Giovanella 
<coreygiovanella@challenge-engineering.com> wrote:

> I've posted the source and perhaps a better description on my web site:
> http://challenge-engineering.com/~corey/projects/fake_if/

You're echoing iptables packet counts into a fake interface to make it 
available to an existing graphical monitor application. The app has a 
plugin system, so wouldn't it be better to write an iptables plugin for it? 
What's the advantage of copying the counters to another kernel object?

The fake interface is an interesting object but maybe not the best solution 
for this particular problem.

Given a general iptables plugin, this would make a good replacement for 
ntop as a packet-counting protocol analyzer. I find ntop (which uses 
libpcap) a bit "heavyweight" for just counting packets, as it also does 
deep analysis of their content and hence uses a fair amount of memory and 
CPU. (ntop also exposes the data via web interface, which is nice for 
non-Linux clients.)
