From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables and external processes
Date: Wed, 18 Feb 2004 07:27:17 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402180726110.10256-100000@filer.marasystems.com>
References: <1077085236.2010.31.camel@ca.gts.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allen Francom <aef@prismnet.com>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1077085236.2010.31.camel@ca.gts.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 18 Feb 2004, John A. Sullivan III wrote:

> It sounds like this would be a problem using QUEUE.  Have I understood
> you correctly? Thanks - John

You can not use QUEUE between rules in the same table. Only as final rule 
in a table. Changing this is far from trivial.

Regards
Henrik
