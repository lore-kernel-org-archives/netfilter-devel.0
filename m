From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Proposal] ip_conntrack_tuple extension for advanced matching
Date: Tue, 26 Sep 2006 12:00:01 +0200
Message-ID: <4518FA21.8070607@trash.net>
References: <451448A9.6000407@gmx.net>	<4515F7F8.9030000@netfilter.org>	<4516C70A.3050502@gmx.net>	<451700B1.7070103@rtij.nl>	<4517E205.8090807@gmx.net>	<45182332.8090303@rtij.nl>
	<45184198.1060906@gmx.net> <45186AC3.6080505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45186AC3.6080505@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Carl-Daniel Hailfinger wrote:
> 
>>Would a patch for adding such a feature be accepted into mainline?
> 
> 
> IHMO, your numering schema is not convenient. I would not accept such
> patch since I can't see any other utility apart from supporting your
> setting.

Me neither, the network setup is obviously broken. Its also a bit harder
than just extending the conntrack keys, you need also need to take care
of NAT unique tuple generation, expectations and ICMP error tracking.
That still leaves a few corner cases, but nothing terribly important.
