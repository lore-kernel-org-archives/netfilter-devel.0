From: Patrick McHardy <kaber@trash.net>
Subject: Re: Question about IP rerouting at POST_ROUTE_HOOK
Date: Mon, 01 Mar 2004 16:25:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404355FF.5010305@trash.net>
References: <OFAFE494A0.B2169671-ON88256E4A.000CABC4@tais.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Glenn.Swonk@tais.com
In-Reply-To: <OFAFE494A0.B2169671-ON88256E4A.000CABC4@tais.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Glenn.Swonk@tais.com wrote:
> I have written a netfilter module that loads as a kernel loadable module.
> 
> I am hooking into the NF_IP_POST_ROUTING hook.
> 
> I am trying to change the destination (IP address) of the packet at this
> point and am having a problem.
> 
> I am able to change the dest IP address but it is sent out with the
> original IP destination's  MAC address.
> 
> I cannot seem to change the destination MAC address at this point.

You need to make a new route lookup with the changed IP.
The easiest way of doing so is using ip_route_me_harder, it also
does all the work like relocating the packet if the headroom is
too small for the new output device etc.

Regards
Patrick

> 
> Is there a problem with changing the IP address (by manipulation of the
> skbuf data structure) or
> is a better method.
> 
> Any suggestions?
> 
> thanks,
> glenn
> 
> 
> 
> 
> 
> 
> 
> Glenn Swonk
> Toshiba America Information System
> 9740 Irvine Blvd.
> Irvine, CA 92618
> 
> 949-587-6530
> gswonk at tais.com
> 
> Not Done = Less than 100%
> Testing is never finished, only abandoned...
> 
> 
