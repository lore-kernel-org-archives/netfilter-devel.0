From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Fri, 23 Jan 2004 16:56:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401231655030.16986-100000@filer.marasystems.com>
References: <4011325F.6030308@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michal Ludvig <mludvig@suse.cz>
In-Reply-To: <4011325F.6030308@suse.cz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Jan 2004, Michal Ludvig wrote:

> Yes, that's true. But how to solve it? The best would be to skip the 
> first POSTROUTING if the packet won't be encapsulated. But we can't know 
> whether or not it will go to IPsec until we perform NAT on it.

As I said the hook needs to be just before the packet is about to enter 
IPSec.

Any decisions on what to IPSec or not needs to be based on other 
information than NAT, i.e. via nfmark routing or similar.

Regards
Henrik
