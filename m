From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: BUG: net/netfilter: KASAN: stack-out-of-bounds in tcp_packet
Date: Mon, 28 Mar 2016 19:05:43 +0200
Message-ID: <20160328170543.GA31104@salvia>
References: <56F7D3AD.10003@gmail.com>
 <alpine.DEB.2.10.1603280010120.19633@blackhole.kfki.hu>
 <alpine.DEB.2.10.1603280024160.19777@blackhole.kfki.hu>
 <56F8987B.5030501@gmail.com>
 <56F92E21.30509@gmail.com>
 <alpine.DEB.2.10.1603281844200.23985@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Baozeng Ding <sploving1@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1603281844200.23985@blackhole.kfki.hu>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 28, 2016 at 06:48:51PM +0200, Jozsef Kadlecsik wrote:
> Hi David, Pablo,
> 
> David, do you agree with the patch for net/ipv4/tcp_input.c? If yes, how 
> should I proceed? Should I send the whole patch to you or is it OK to send 
> to Pablo?

Submit a formal patch and Cc: netdev@vger.kernel.org and
netfilter-devel@vger.kernel.org, then we can request David to ack this
if he considers it fine or the other way around (I ack it he takes
it).

Thanks!
