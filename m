From: Martijn Lievaart <m@rtij.nl>
Subject: Talking about recent (was: Re: [PATCH] 2.4.x new amanda conntrack
 + NAT support)
Date: Tue, 01 Apr 2003 10:23:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E894C92.5010801@rtij.nl>
References: <20030330200750.GZ7718@sunbeam.de.gnumonks.org> <20030331.070910.52982765.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20030331.070910.52982765.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>
>
>Harald, what is the state of ipt_recent?  Will I see it soon?
>
>  
>

Talking about recent, I'm not completely happy with the way it is now. 
If I understand things correctly the rcheck decission on matching source 
or destination is not done based on the commandline, but on 
tables->side. But iirc the rsource/rdest argument is happily accepted on 
the rcheck and subsequently ignored. This could be a useful feature, let 
the user decide. In fact, I think the table->side is unneeded, it can 
always be specified at the cost of a little work from the user. I'm 
running such a patch at home, but it is incompatible with existing 
ipt_recent as it ignores table->side. Such would break existing 
installations. I think I see a way of making this work without breaking 
any compatibility. I'll submit a patch once I have it working, based on 
the new recent module.

Why is this useful? F.i. track all outgoing connections and reject with 
tcp reset incomming idents that match the table. Otherwise fall through 
to the default drop. This would need a reversing of source and 
destination between the --set and the --rcheck. This would allow a real 
stealthy firewall that still handles idents in a sane way. I once looked 
at creating a helper for this, but that would need some major surgery on 
the iptables core I think. Using the recent match would be a rather 
clean solution at the cost of some additional memory used. Also, other 
dynamic protocols could be made a little safer by this as well, pending 
a real contrack helper.

(Yes, I know there is a feature freeze, but I'm not in a hurry)

Martijn Lievaart
