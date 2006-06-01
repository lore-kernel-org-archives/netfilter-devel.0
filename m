From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LARTC] iptables CLASSIFY and MARK not working?
Date: Thu, 01 Jun 2006 22:01:36 +0200
Message-ID: <447F47A0.7000104@trash.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB25541A@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB25541A@xavier.staff.greatlakes.net>
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

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> Bridged iptables (ebtables) is not enabled in the kernel and I cannot
> seem to find a variable "bridge-nf-call-iptables" to set with sysctl:
> 
> wireless-r1 linux # sysctl -w bridge-nf-call-iptables=0
> error: "bridge-nf-call-iptables" is an unknown key
> 
> There is also no /proc/sys/net/*/bridge anything. I assume that means
> this is not something I need to worry about?

Not sure yet, the problem would be created by CONFIG_BRIDGE_NETFILTER,
not ebtables itself. Check for
"/proc/sys/net/bridge/bridge-nf-call-iptables".

I'm actually pretty sure that this is indeed what's causing the problem,
bridge netfilter defers calling the IP POST_ROUTING hook until the
packet was already transmitted over the device (and before it goes
out the underlying device), which means when it hits the CLASSIFY
target it already passed through the qdisc.
