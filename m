From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: netfilter connection tracking TIMEOUT issue
Date: Fri, 14 Nov 2003 12:45:24 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311141215330.32644-100000@filer.marasystems.com>
References: <MEEKIEPDOBGHADOEHGGOMEKHCCAA.wsong@ece.uci.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Song Wang <wsong@ece.uci.edu>
In-Reply-To: <MEEKIEPDOBGHADOEHGGOMEKHCCAA.wsong@ece.uci.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 13 Nov 2003, Song Wang wrote:

> of SSH virtual server and deleted the iptables rule, due to the 5 DAYS
> timeout, the remote can still connect to the ssh server within 5 DAYS
> unless I rebooted the gateway or reloaded ip_conntrack module!!!

Not quite.. his already established SSH session will be allowed to last 
for ever (or until idle for 5 days with no packets exchanged), but no new 
SSH sessions will/should be allowed.

Also, this is obviously subject to your ruleset. Only if you accept 
ESTABLISHED sessions without any kind of verification of the session then 
you are at risk of running into this kind of issues.

> I don't know how netfilter designers come up with these TIMEOUT values.
> I searched the mailing list before and there were arguments about it.

By the design of TCP.

ESTABLISHED needs a very long timeout due to the fact that there might not 
be any packets exchanged for a very long time if there is no data to be 
exchanged between the two endpoints.

All these timeouts is related to is the connection tracking of sessions.

It is your firewall rules which accepts/denies packets. Your firewall 
rules can use connection tracking information, but should not do so 
blindly.

> I don't want to argue about these values. But I think we should come up
> with a method that when we delete an iptables rule, at least we can
> easily elect to delete related connection tracking entries in the
> connection tracking table.

See ctnetlink.

You can also look into the CONFIRMED patch submitted by one of my
collegues some months ago (meant to be used together with the conntrack
match). But the scheme used by CONFIRMED is not yet fully polished.

Regards
Henrik
