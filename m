From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: manual connection adding to ip_conntrack hash table
Date: Fri, 16 Jan 2004 17:53:47 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401161721460.30706-100000@filer.marasystems.com>
References: <14603099.20040116153336@post.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Konrad D." <darnok@post.pl>
In-Reply-To: <14603099.20040116153336@post.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 16 Jan 2004, Konrad D. wrote:

> I'm in the course of writing my thesis about connection tracking in netfilter,
> it's sad but I need help. So I'm asking for help you, the netfilter developers.
> Topic of my thesis is High Availability Firewall.

There has been several projects aiming to add connection tracking
synchronisation/failover to netfiler, but so far it is not completed.

The most current and active is netfilter-ha which can be browsed at
http://cvs.netfilter.org/netfilter-ha/ with mailinglist at 
http://lists.netfilter.org/mailman/listinfo/netfilter-failover

Regards
Henrik
