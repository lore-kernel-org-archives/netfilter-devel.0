From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: FW: injecting new packets into the netfilter
Date: Wed, 30 Jun 2004 12:46:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301245070.3767-100000@filer.marasystems.com>
References: <BNELKLECKCDLOPNOBHFHMEBOJEAA.mayank_kumar@intersolutions.stpn.soft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: aksingh@hss.hns.com, <netfilter@lists.netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mayank Kumar <mayank_kumar@intersolutions.stpn.soft.net>
In-Reply-To: <BNELKLECKCDLOPNOBHFHMEBOJEAA.mayank_kumar@intersolutions.stpn.soft.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Mayank Kumar wrote:

> I want to know how can u send new packets in the kernel the 
> same way libnet does. The idea is that after i have returned
> NF_STOLEN from inside my hook functions in the kernel modules,
> i want to queue them toa kernel thread.

See for example the REJECT target. This creates ICMP or even TCP packets
in response to the traffic to reject.

Regards
Henrik
