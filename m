From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: Proxy ARP doesn't seem to be working. Please assist.
Date: Tue, 01 Feb 2005 10:08:34 +0100
Message-ID: <1107248914.4082.23.camel@bzorp.balabit>
References: <68B9548ED9F8A341B21CDB320655D613F54E4D@mercury.nmwco.com>
	<41FE91E0.6070004@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <41FE91E0.6070004@rtij.nl>
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

Though very off-topic here, the solution probably is that you need to
have a route pointing to a different interface for the kernel to respond
to a proxy arp request.

E.g. add a route entry for the specific IP address(es) pointing to a
different interface. If you want to process those packets locally
(instead of forwarding it) then configure an alias IP address (using
either the ifconfig eth0:1 trick or using ip addr add)

On Mon, 2005-01-31 at 21:15 +0100, Martijn Lievaart wrote:
> Aaron Stavens wrote:
> 
> >Martijn Lievaart over on the netfilter list suggested I post my query
> >here. I am trying to set up proxy ARP. As far as he can tell, I'm doing
> >  
> >
> 
> I actually said the net-devel list , not the netfilter-devl list, but 
> maybe someone here knows about this too.
> 
> >it right, but it is working for neither him nor me. Martijn claims this
> >method used to work in the 2.2 kernel. Has something changed?
> >  
> >
-- 
Bazsi
