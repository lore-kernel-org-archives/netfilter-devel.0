From: Stephen Jones <hivemynd@hivemynd.net>
Subject: Re: Patch-o-matic cleanup
Date: Tue, 04 Apr 2006 09:39:50 -0500
Message-ID: <44328536.6070902@hivemynd.net>
References: <443165AA.4030509@trash.net> <44321188.30902@hivemynd.net>
	<4432306C.10106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4432306C.10106@trash.net>
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

Patrick McHardy wrote:
> Stephen Jones wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>>- pptp-conntrack-nat: in mainline now, patches are missing critical
>>>  fixes
>>
>>Hi Patrick,
>>
>>Is pptp-conntrack-nat functionality going to be included in the 2.4.x
>>mainline also?  Otherwise, the patches still appear to be necessary for
>>2.4.x kernels.
> 
> 
> No, 2.4 is in absolute stable mode. The pptp patches for 2.4 are missing
> a number of important bugfixes, I wouldn't recommend using them in their
> present form. We don't have the time to maintain old versions forever,
> which is why we decided to remove this old stuff.
> 
> 
Ok, good enough, and completely understandable.  Unfortunately, for me, 
there are still quite a few items (not netfilter related) that work on 
2.4.x that do not yet work on 2.6.x series kernels that force me into a 
holding pattern on the 2.4.3x kernels for now.  I'll keep an archive of 
the last known working iptables + pom-ng snapshot if I need to recompile 
again in the future.  The pptp conntrack functionality has been "mostly" 
working for us for several years now. The problems with it are rare and 
tend to occur when the linux firewall is managing many concurrent 
tunnels, otherwise it appears to work just fine. Thank you for your reply.

SJ
