From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Idea: Check session source and destination
Date: Mon, 26 Apr 2004 16:44:34 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404261640210.6443-100000@filer.marasystems.com>
References: <427EA2C2-9787-11D8-8B47-000A957FD99E@src.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>,
   <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mike Andersen <mike@src.no>
In-Reply-To: <427EA2C2-9787-11D8-8B47-000A957FD99E@src.no>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 26 Apr 2004, Mike Andersen wrote:

> iptables -A FORWARD -m conntrack --ctorigdst <int_ip> -j ACCEPT
> iptables -A FORWARD -j DROP

Works here..

> I then look more closely at the state table (/proc/net/ip_conntrack)  
> and see that there are two sets of source definition, and two sets for  
> the destination:

One is the ORIGINAL direction, the other the REPLY direction. Each is 
matched independently by the "conntrack" match (--ctorigdst vs 
--ctreplydst).

> Any idea of why the "-m conntrack --ctorigdst <int_ip>" also passes  
> through traffic where int_ip is the source of the session?

Does work like intended here and only matches where it is the original
destination. But I am using this for packet filtering, not mirroring.  
Not that I see any difference. Also I am using an extended version of the
conntrack match which can match additional deatils such as ports etc,
based on the conntrack match found in patch-o-matic-ng. (see
netfilter-devel discussions some many months ago).. but that should not 
make any difference either.

Regards
Henrik
