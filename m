From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT question
Date: Wed, 30 Jun 2004 13:55:29 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301351530.7534-100000@filer.marasystems.com>
References: <20040630113602.963604C052@spy10.spymac.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiran Kumar Immidi <immidi@spymac.com>
In-Reply-To: <20040630113602.963604C052@spy10.spymac.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Kiran Kumar Immidi wrote:

> When packets are being masqueraded from multiple machines through a NAT box,
> how would the response be identified as part of a particular connection.

By it's ip:port tuple (both source and destination).

> So, if we have (identical, as regards port numbers and dest ip address)
> packets from A and B snatted at C, how is the reply (to C) identified as
> belonging to either A or B?

By which port on C the reply traffic is addressed to.

The NAT engine always guarantees that at least one field in the address 
tuple (source ip,port destination ip,port) is different as required to 
correctly identify individual connections for all involved.

Regards
Henrk
