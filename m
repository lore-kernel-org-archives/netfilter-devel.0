From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables and external processes
Date: Wed, 18 Feb 2004 05:51:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402180549200.10256-100000@filer.marasystems.com>
References: <20040217161130.K27680@tempest.prismnet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Allen Francom <aef@prismnet.com>
In-Reply-To: <20040217161130.K27680@tempest.prismnet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Allen Francom wrote:

> I thought it was possible to actually change the packet
> and send the packet back in again ?

Yes.

> Just rule processing stops once -J QUEUE happens ?

Yes.

And the verdict from QUEUE is final for this hook. iptables will NOT 
continue on the next rule.

Regards
Henrik
