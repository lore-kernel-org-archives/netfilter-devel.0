From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 21 Jun 2005 01:27:31 +0200
Message-ID: <42B750E3.4070209@trash.net>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
	<20050620185736.GA4883@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net,
	rankincj@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050620185736.GA4883@linuxace.com>
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

Phil Oester wrote:
> The changes were originally made to fix conntrack unload problems with
> raw sockets.  My original patch performed the nf_reset in the socket
> code, but Patrick suggested moving it to ip_output.  The below patch
> reverts the ip_output changes, and implements the original suggested
> changes to raw socket handling.  
> 
> While this is unlikely to be the permanent solution, it will fix the
> current bridging problems while retaining the raw socket fixes.  I'd
> suggest that this could be included in -stable while researching
> other solutions.

I disagree. We will probably have a final solution within a few days,
so I don't think we need to submit "temporary" fixes yet. Your patch
actually causes a regression for people not using bringe-netfilter,
unplugging a network cable can cause the conntrack module to become
unloadable again.

Regards
Patrick
