From: =?UTF-8?B?QXJ0xatyYXMgxaBsYWp1cw==?= <x11@arturaz.net>
Subject: Re: Need an iptables module for hiding NAT.
Date: Tue, 06 Feb 2007 16:39:51 +0200
Message-ID: <45C89337.4020907@arturaz.net>
References: <45C75479.3090605@arturaz.net>	<200702052316.14477@auguste.remlab.net>
	<1170715282.24701.13.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <rdenis@simphalempin.com>,
	netfilter-devel@lists.netfilter.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1170715282.24701.13.camel@henriknordstrom.net>
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

Henrik Nordstrom wrote:
> I keep my recommendation of using a proxy, and netfilter NAT or TPROXY
> to deliver the traffic to the proxy. If you want to get fancy you can
> combine it with a NFQUEUE filter to defer SYN from being delivered to
> the proxy until you know the site is reachable..

excuse me, what do you mean using proxy? Something like squid?
