From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: help wanted regarding connction limits.
Date: Tue, 27 Apr 2004 23:37:58 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404272328380.29115-100000@filer.marasystems.com>
References: <20040427212007.42770.qmail@web41908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Null Device <nulldevice83@yahoo.com>
In-Reply-To: <20040427212007.42770.qmail@web41908.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Apr 2004, Null Device wrote:

> well he prob is i am unable to make out how can i
> integrate this code in mine own module.

Just do the same things as this module is doing in your own netfilter 
module.

It is not practical to call iptables modules from other netfilter modules,
but practically anything iptables modules do wrt packet matching can you
do in your netfilter modules in the same manner.

> "Connection Tarcking Helper Module", I tried
> ip_conntrack_helper_register(&modified_connlimit) in
> my module.

This is a completely different thing, only relevant if you need to 
implement connection tracking helpers for parsing various protocols. FTP 
is a good example requiring this to figure our that the data transfers 
belong to the same FTP session.

> But then i realized, connlimit depends on usual
> parametesr which are supposed to be passed to the
> matching function when i registers with
> ip_register_match ie ptr to skbuff, in and out
> devices, ptr to header, and ptr to match info.
> And i was lost in the dark how can make it work.

You are simply looking too hard at connlimit.

What you need in your module is a equivalence to the connlimit match() 
function and anything used by this function. Any arguments such as 
interfaces, offset etc not used by the connlimit match() function can be 
ignored as these are just artifacts of the iptables module interface.

The hotdrop thing can also be ignored. This is just a way for an iptables 
match to say the packet is invalid and should be dropped to not conflict 
with the match. In a netfilter module this is the same as returning 
NF_DROP.

There will automatically be a dependency on netfilter conntrack, and the 
info returned from ip_conntrack_get can be used to determine if this is a 
new or ongoing connection.

Regards
Henrik
