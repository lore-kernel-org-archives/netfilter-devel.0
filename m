From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Connection tracking bug with DNAT?
Date: Sat, 27 Mar 2004 22:53:05 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403272250450.23501-100000@filer.marasystems.com>
References: <20040327162415.63769.qmail@web21323.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Old Cowhand <oldcowhanddoug@yahoo.com>
In-Reply-To: <20040327162415.63769.qmail@web21323.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 27 Mar 2004, Old Cowhand wrote:

> with a destination of .5 on eth0.  I see the DNAT rule
> match in iptables -L -n -v -t nat.  I see the HTTP
> request go on eth1 to .15 (DNAT rule works).  I see
> the HTTP server at .15 reply to 172.16.1.2 on eth1. 
> The data is dropped and never returned after that. 
> The reply never appears on eth0.

Triple check your routing on both the NAT gateway and the web server.

What you are trying to do is a pretty standard setup and has always worked
just beautifylly in all my tests "for ever"..

Regards
Henrik
