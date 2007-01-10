From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.20-rc4: regression: iptables failed to load rules
Date: Wed, 10 Jan 2007 17:10:27 -0500
Message-ID: <45A56453.9060707@tmr.com>
References: <5157576d0701082329o1875911j20f6679e2d35bb17@mail.gmail.com>
	<Pine.LNX.4.64.0701090929160.3594@woody.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bunk@stusta.de
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701090929160.3594@woody.osdl.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 9 Jan 2007, Tomasz Kvarsin wrote:
>> During boot into 2.6.20-rc4 iptables says
>> iptables-restore: line 15 failed.
>> And works fine with my default kernel: 2.6.18.x
> 
> I bet you enabled the new transport-agnostic netfilter, and didn't enable 
> some of the actual rules needed for your iptables setup (they have new 
> config names).
> 
> I do think that the netfilter team has been very irritating in changing 
> the config names, even if it "is logical". 
> 
> Somebody should stop the madness, and tell people what config options they 
> need for a regular iptables setup like this. Rather than say "just compile 
> everything". There's about a million different filters, and they all 
> depend on one infrastructure or another.
> 
> And then the networking people should F*NG STOP that config name changing 
> madness! The config names should match the _usage_, not some 
> implementation detail. And failing that, leave the config options named 
> something illogical, as long as people don't have to change their config 
> file all the time and answer millions of questions that they don't care 
> about!

This could apply to some other things, like PAE support. Instead of 
having to know what memory models set what option which impact 
virtualization, set the option if the feature is needed for any config 
option choice. This probably hits people wanting virtualization on small 
memory machines more than others.
