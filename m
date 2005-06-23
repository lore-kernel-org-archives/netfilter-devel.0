From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [Ebtables-devel] Re: 2.6.12: connection tracking broken?
Date: Thu, 23 Jun 2005 06:27:49 +0000
Message-ID: <1119508069.3387.20.camel@localhost.localdomain>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
	<42B74FC5.3070404@trash.net>
	<1119338382.3390.24.camel@localhost.localdomain>
	<42B82F35.3040909@trash.net>
	<20050622214920.GA13519@gondor.apana.org.au>
	<42B9FC19.2000604@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, rankincj@yahoo.com,
	Patrick McHardy <kaber@trash.net>, netfilter-devel@manty.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
In-Reply-To: <42B9FC19.2000604@gmx.net>
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

Op do, 23-06-2005 te 02:02 +0200, schreef Carl-Daniel Hailfinger:
> For my local setup it is already a minor PITA that there is no tool
> combining the functionality of arptables, ebtables and iptables, but
> I can cope with the help of marking and ipt_physdev. If that doesn't
> work reliably anymore, I'll be stuck.
> 
> Wasn't someone working on a unified framework for *tables? IIRC that
> would have been pkttables, but Harald(?) said there was not much
> code there yet.

On my todo list is making the arptables matches usable in ebtables
rules. I think it would be very nice if {eb,ip,ip6,arp}tables modules
could be used together.

cheers,
Bart
