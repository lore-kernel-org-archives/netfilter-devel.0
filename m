From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NF_ACCEPT behaviour
Date: Thu, 8 Jan 2004 20:37:32 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401082036480.17722-100000@filer.marasystems.com>
References: <751519739.20040108192008@csp.kazan.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: admin@csp.kazan.ru
In-Reply-To: <751519739.20040108192008@csp.kazan.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 8 Jan 2004 admin@csp.kazan.ru wrote:

> When i apply NF_ACCEPT on packet, the packet continues its motion
> through firewall chains, listed after "-j QUEUE"  rule?

No, QUEUE:ed packets continue on the next hook when reinserted to the 
kernel.

Regards
Henrid
