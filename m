From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: H.323 progress.
Date: Wed, 19 May 2004 08:15:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405190814480.19467-100000@filer.marasystems.com>
References: <40AA6E99.20900@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard Scobie <richard@sauce.co.nz>
In-Reply-To: <40AA6E99.20900@sauce.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 19 May 2004, Richard Scobie wrote:

> Two offices each with an iptables firewall and a site to site VPN 
> between them - the video gear is configured to connect to each others 
> private network address through the VPN.

Is the traffic between the two offices NAT:ed, or just forwarded over the 
VPN?

There should be no need for NAT on office<->office traffic.

Regards
Henrik
