From: "David S. Miller" <davem@redhat.com>
Subject: Re: iptables+2.6-test8-bk4 : Still problems
Date: Wed, 29 Oct 2003 10:34:48 -0800
Sender: sparclinux-owner@vger.kernel.org
Message-ID: <20031029103448.7255b095.davem@redhat.com>
References: <3F9B8A5D.9010803@triaton-webhosting.com>
	<200310261052.25944.rezso@rdsor.ro>
	<20031026223438.1cf757ce.davem@redhat.com>
	<3F9ED206.4040806@triaton-webhosting.com>
	<20031028231317.7840e47f.davem@redhat.com>
	<Pine.LNX.4.58.0310291303270.22903@ryanspc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: georg.chini@triaton-webhosting.com, rezso@rdsor.ro,
	sparclinux@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <sparclinux-owner@vger.kernel.org>
To: Ryan Veety <ryan@ryanspc.com>
In-Reply-To: <Pine.LNX.4.58.0310291303270.22903@ryanspc.com>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Oct 2003 13:20:30 -0500 (EST)
Ryan Veety <ryan@ryanspc.com> wrote:

> # iptables -A INPUT -i eth0 -p icmp -m limit --limit 10/second -j ACCEPT
> iptables: Invalid argument
> 
> No biggie for me, just happened to notice it.

I suspect it's the "unsigned long" in "struct ipt_rateinfo", we'd need
to translate these structures going in/out of netfilter :-(

There are a bunch of other iptables target modules that would need
similar translations.
