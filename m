From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 11:37:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com>
References: <20031020071545.GA21521@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031020071545.GA21521@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 20 Oct 2003, Harald Welte wrote:

> again, this seems a shortcoming of the netlink infrastructure.  This
> would be much better, if we'd actually have a reference to the socket of
> the userspace process (since table dumps could be unicast anyway...).

If it is a shortcoming of netlink or a shortcoming of how to reliably dump 
the content of a large hash buckets can be argued, but I tend to agree 
with you here.

The dump operation should be connetion oriented with the userspace 
application, not purely datagram based. The kernel should know for certain 
if the userspace application terminates a dump operation mid-air.

Regards
Henrik
