From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Problems using libipq/QUEUE
Date: Wed, 30 Jun 2004 18:58:45 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301857210.12023-100000@filer.marasystems.com>
References: <200406301259.i5UCxNMX021493@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200406301259.i5UCxNMX021493@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Muhammad R. Sami wrote:

> iptables -A OUTPUT -p icmp -j QUEUE
> 
> Now this should queue all originating ping packets and then depending on the
> NF mark action will be taken. But it seems that regardless of the NF mark,
> all icmp traffic is blocked. As I remove the above rule from the iptables,
> things work fine.

You don't seem to be using the nfmark in this simple ruleset...

Regards
Henrik
