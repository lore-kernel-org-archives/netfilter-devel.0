From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT & FORWARDING
Date: Sat, 31 Jan 2004 10:30:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401311026420.17639-100000@filer.marasystems.com>
References: <200401301020.53669.sshebbar@yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Srinivasa Hebbar <sshebbar@yahoo.com>
In-Reply-To: <200401301020.53669.sshebbar@yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 30 Jan 2004, Srinivasa Hebbar wrote:

> Your solution works fine for me.
> Actually, I want to know how I can build a NAT rule 
> which will have "and" condition.
>
> My box has atleast 50 interfaces and I want to do NAT on
> all interfaces except "eth0" and "xpeth0"

AND is a little tricky for the built-in matches, but what you can do is to 
use a custom chain and RETURN.

iptables -t nat -N NAT3021
iptables -t nat -A NAT3021 -i eth0 -j RETURN
iptables -t nat -A NAT3021 -i xpeth0 -j RETURN
iptables -t nat -A NAT3021 -j DNAT ....
iptables -t nat -A PREROUTING -p tcp --dport 3021 -j NAT3021

Regards
Henrik
