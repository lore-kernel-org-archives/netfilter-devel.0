From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: 2.6.20-rc4: regression: iptables failed to load rules
Date: Tue, 9 Jan 2007 09:33:32 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701090929160.3594@woody.osdl.org>
References: <5157576d0701082329o1875911j20f6679e2d35bb17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: bunk@stusta.de,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932289AbXAIRd5@vger.kernel.org>
To: Tomasz Kvarsin <kvarsin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <5157576d0701082329o1875911j20f6679e2d35bb17@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On Tue, 9 Jan 2007, Tomasz Kvarsin wrote:
>
> During boot into 2.6.20-rc4 iptables says
> iptables-restore: line 15 failed.
> And works fine with my default kernel: 2.6.18.x

I bet you enabled the new transport-agnostic netfilter, and didn't enable 
some of the actual rules needed for your iptables setup (they have new 
config names).

I do think that the netfilter team has been very irritating in changing 
the config names, even if it "is logical". 

Somebody should stop the madness, and tell people what config options they 
need for a regular iptables setup like this. Rather than say "just compile 
everything". There's about a million different filters, and they all 
depend on one infrastructure or another.

And then the networking people should F*NG STOP that config name changing 
madness! The config names should match the _usage_, not some 
implementation detail. And failing that, leave the config options named 
something illogical, as long as people don't have to change their config 
file all the time and answer millions of questions that they don't care 
about!

David, please crack some heads.

		Linus
