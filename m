From: Allen Francom <aef@prismnet.com>
Subject: Re: iptables and external processes
Date: Tue, 17 Feb 2004 16:13:43 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217161130.K27680@tempest.prismnet.com>
References: <Pine.LNX.4.44.0402172303080.3844-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402172303080.3844-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I thought it was possible to actually change the packet
and send the packet back in again ?

Just rule processing stops once -J QUEUE happens ?

There are also some other tools like Snort and Hogwash
and probably a few more by now that have different
capabilities for inspecting packets.

FYI
-AEF

On Tue, 17 Feb 2004, Henrik Nordstrom wrote:
> On Tue, 17 Feb 2004, John A. Sullivan III wrote:
>
> > It would solve a very difficult problem for us if we could jump a packet
> > to a chain based upon the decision of a process external to iptables.
>
> The QUEUE function is pretty similar to this. Only difference is that the
> verdict from QUEUE is final for the hook.
