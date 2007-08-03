From: Philip Craig <philipc@snapgear.com>
Subject: Re: conntrack: UDP NAT vs. VPN tunnel
Date: Fri, 03 Aug 2007 10:25:37 +1000
Message-ID: <46B27601.8000505@snapgear.com>
References: <200708021817.38209.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200708021817.38209.thomas.jarosch@intra2net.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Thomas Jarosch wrote:
> I've now searched for possible solutions. I could write a program that gets 
> called after the VPN tunnel is reestablished and deletes all UDP NAT 
> conntracks matching the IPs of the VPN tunnel. This is rather complex,
> but possible. Maybe there is a more simple solution?

Add a filter rule that drops packets with a VPN destination that are
not going over the VPN.  Then the conntrack is never created until
the VPN is up.  This is good for security too, so that you aren't
leaking private data.

[BTW, the netfilter list is more appropriate for this question.]
