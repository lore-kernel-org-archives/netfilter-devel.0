From: Glenn.Swonk@tais.com
Subject: Question about IP rerouting at POST_ROUTE_HOOK
Date: Sun, 29 Feb 2004 18:21:11 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OFAFE494A0.B2169671-ON88256E4A.000CABC4@tais.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have written a netfilter module that loads as a kernel loadable module.

I am hooking into the NF_IP_POST_ROUTING hook.

I am trying to change the destination (IP address) of the packet at this
point and am having a problem.

I am able to change the dest IP address but it is sent out with the
original IP destination's  MAC address.

I cannot seem to change the destination MAC address at this point.

Is there a problem with changing the IP address (by manipulation of the
skbuf data structure) or
is a better method.

Any suggestions?

thanks,
glenn







Glenn Swonk
Toshiba America Information System
9740 Irvine Blvd.
Irvine, CA 92618

949-587-6530
gswonk at tais.com

Not Done = Less than 100%
Testing is never finished, only abandoned...
