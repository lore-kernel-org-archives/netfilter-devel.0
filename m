From: Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 21 Jun 2005 20:46:12 +0000
Message-ID: <1119386772.3379.4.camel@localhost.localdomain>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	 <Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	 <1119249575.3387.3.camel@localhost.localdomain> <42B6B373.20507@trash.net>
	 <1119293193.3381.9.camel@localhost.localdomain>
	 <42B74FC5.3070404@trash.net>
	 <1119338382.3390.24.camel@localhost.localdomain>
	 <42B82F35.3040909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym-CNXmb7IdZIWZIoH1IeqzKA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	netfilter-devel-wool9L35kiczKOhml7GhPkB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	rankincj-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	netfilter-devel-gaW6/AuhO2xeoWH0uzbU5w@public.gmane.org
Return-path: <ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
To: Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
In-Reply-To: <42B82F35.3040909-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
Sender: ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=ebtables-devel>
List-Id: netfilter-devel.vger.kernel.org

Op di, 21-06-2005 te 17:16 +0200, schreef Patrick McHardy:
> I unfortunately don't see a way to remove it, but we should keep
> thinking about it. Can you please check if the attached patch is
> correct? It should exclude all packets handled by bridge-netfilter
> from having their conntrack reference dropped. I didn't add nf_reset()'s
> to the bridging code because with tc actions the packets can end up
> anywhere else anyway, and this will hopefully get fixed right sometime.

Looks good.
Perhaps a compile time option to disable postponing the hooks would be
nice...

> BTW. this line from ip_sabotage_out() looks wrong, it will clear all
> flags instead of setting the BRNF_DONT_TAKE_PARENT flag (second
> patch):
> 
>                         nf_bridge->mask &= BRNF_DONT_TAKE_PARENT;

Thanks,
Bart




-------------------------------------------------------
SF.Net email is sponsored by: Discover Easy Linux Migration Strategies
from IBM. Find simple to follow Roadmaps, straightforward articles,
informative Webcasts and more! Get everything you need to get up to
speed, fast. http://ads.osdn.com/?ad_id=7477&alloc_id=16492&op=click
