From: Patrick McHardy <kaber@trash.net>
Subject: Re: Established SNAT packets sometimes marked as INVALID
Date: Tue, 13 Feb 2007 12:42:24 +0100
Message-ID: <45D1A420.7050107@trash.net>
References: <20070131171808.AAS61183@mira.spsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jim Herbert <jherbert@spsu.edu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070131171808.AAS61183@mira.spsu.edu>
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

Jim Herbert wrote:
> Hi,
> 
> We've been running a Linux firewall and using NAT for about 8 years without a hitch, but we've just encountered an issue where internal addresses can only receive partial data from specific external sites.  I've taken a sniff on the public side of our firewall and found that while the initial packets from our internal private subnets do traverse NAT tables, shortly into the conversation they are being marked as INVALID, bypassing the NAT translation and are forwarded to our upstream provider.
> 
> In the scenario below, 10.220.2.244 is an IP in our internal private network.  168.28.180.22 is one of several public interfaces on our NAT gateway and 131.146.8.66 is the web site (www.oracle.com) which we are attempting to view.  As you can see, the initial conversation takes place between 168.28.180.22 and 141.146.8.66, but later becomes a conversation between 10.220.2.244 and 141.146.8.66.  I placed a log on the 10.220.2.244 IP and found it was being classified as INVALID at the point it all falls apart.
> 
> The firewall is running RHEL4-64 and kernel 2.6.9-42.0.8.ELsmp.  We are using SNAT.  This behavior comes and goes and most oddly, only seems to occur with our Windows clients.  No packets are marked as invalid coming from Linux boxes on the same private source nat'd network.
> 
> You can find an ethereal trace from the public side below.  Any help would be greatly appreciated!

Please enable conntrack logging by doing:

echo 255 >/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid
modprobe ipt_LOG

and post the results.
