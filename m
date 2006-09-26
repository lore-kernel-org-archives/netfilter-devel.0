From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: [Proposal] ip_conntrack_tuple extension for advanced matching
Date: Tue, 26 Sep 2006 15:45:34 +0200 (CEST)
Message-ID: <21117.0007860803$1159278472@news.gmane.org>
References: <451448A9.6000407@gmx.net>	<4515F7F8.9030000@netfilter.org>	<4516C70A.3050502@gmx.net>	<451700B1.7070103@rtij.nl>	<4517E205.8090807@gmx.net>	<45182332.8090303@rtij.nl>
	<45184198.1060906@gmx.net> <45186AC3.6080505@netfilter.org>
	<4518FA21.8070607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4518FA21.8070607@trash.net>
To: "Patrick McHardy" <kaber@trash.net>
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

<citaat van="Patrick McHardy">
> Pablo Neira Ayuso wrote:
>> Carl-Daniel Hailfinger wrote:
>>
>>>Would a patch for adding such a feature be accepted into mainline?
>>
>>
>> IHMO, your numering schema is not convenient. I would not accept such
>> patch since I can't see any other utility apart from supporting your
>> setting.
>
> Me neither, the network setup is obviously broken. Its also a bit harder
> than just extending the conntrack keys, you need also need to take care
> of NAT unique tuple generation, expectations and ICMP error tracking.
> That still leaves a few corner cases, but nothing terribly important.

This would be possible with multiple network stacks (aka virtual routers),
something I've been thinking about but is way beyond my capabilities.

It would be pretty cool to have multiple stacks, f.i. one for management
while the other does the firewalling.

M4
