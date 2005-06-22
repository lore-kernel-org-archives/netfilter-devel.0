From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Wed, 22 Jun 2005 02:45:49 +0200
Message-ID: <42B8B4BD.107@trash.net>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>	
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>	
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>	
	<1119293193.3381.9.camel@localhost.localdomain>	
	<42B74FC5.3070404@trash.net>	
	<1119338382.3390.24.camel@localhost.localdomain>	
	<42B82F35.3040909@trash.net>
	<1119386772.3379.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net,
	rankincj@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <1119386772.3379.4.camel@localhost.localdomain>
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

Bart De Schuymer wrote:
> Op di, 21-06-2005 te 17:16 +0200, schreef Patrick McHardy:
> 
>>I unfortunately don't see a way to remove it, but we should keep
>>thinking about it. Can you please check if the attached patch is
>>correct? It should exclude all packets handled by bridge-netfilter
>>from having their conntrack reference dropped. I didn't add nf_reset()'s
>>to the bridging code because with tc actions the packets can end up
>>anywhere else anyway, and this will hopefully get fixed right sometime.
> 
> Looks good.

Thanks.

> Perhaps a compile time option to disable postponing the hooks would be
> nice...

I think we want to reduce the number of possible paths to ideally one,
not make them a compile-time option.

Regards
Patrick
