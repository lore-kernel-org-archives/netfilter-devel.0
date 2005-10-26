From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack-0.81
Date: Wed, 26 Oct 2005 09:15:30 +0200
Message-ID: <435F2D12.7050003@eurodev.net>
References: <20051026030113.8DA3F42B2@daahman.cosmicfires.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Walker <david@cosmicfires.com>
In-Reply-To: <20051026030113.8DA3F42B2@daahman.cosmicfires.com>
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

Hi,

David Walker wrote:
> I'm using conntrack-0.81, libnfnetlink-0.0.10, libnfnetlink_conntrack-0.0.10, 
> linux-2.6.14-rc5 on my bridging firewall.
> 
> When I list the connection table with:
> 
>>conntrack -L
> 
> unknown  0 431987 src=0.0.0.0 dst=0.0.0.0 src=0.0.0.0 dst=0.0.0.0 [ASSURED] 
> mark=0 use=1 id=351262
> ...
> 
> I don't get the protocol or ip addresses. 
> 
>>cat /proc/net/ip_conntrack
> 
> tcp      6 431993 ESTABLISHED src=216.231.49.19 dst=81.59.116.198 sport=55734 
> dport=6346 packets=6406 bytes=2232236 src=81.59.116.198 dst=216.231.49.19 
> sport=6346 dport=55734 packets=8115 bytes=7268987 [ASSURED] mark=0 use=1
> ...
> displays the protocol and ip addresses.
> 
> Is this caused by something I'm doing wrong?

*A lot of changes* has been applied to conntrack and the userspace 
libraries last days, some of them to keep them in sync with kernelspace 
changes. Please check out a working copy from netfilter SVN, that will 
fix your problem.

I still have some things that I want to do before the first 1.0 release, 
among them learning how to add new releases to the netfilter.org 
webpage, Harald? any help?

--
Pablo
