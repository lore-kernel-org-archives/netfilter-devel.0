From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Flushing Conntrack Entrys
Date: Fri, 20 Aug 2004 13:09:09 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408201304280.24377@filer.marasystems.com>
References: <009a01c4865a$72e55fb0$5746370a@nsp.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: VeNoMouS <venom@gen-x.co.nz>
In-Reply-To: <009a01c4865a$72e55fb0$5746370a@nsp.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Aug 2004, VeNoMouS wrote:

> How hard would it be to flush conntrack entries matching to a certain ip?

See ctnetlink for an official API for doing this kind of stuff.

Or if you want to do it in kernelspace see the MASQUERADE target. It does 
exacly this when the IP of the MASQUERADE:d interface changes.

Or you could continue filtering the traffic even if the connection is not 
NEW. CONNMARK could be helpful there to aid in information about the 
specific connection especially so if there is NAT involved.

> now how badly would the conntrack go mental if i were to delete an entry 
> from the conntrack with some code.

It should be quite happy.

Regards
Henrik
