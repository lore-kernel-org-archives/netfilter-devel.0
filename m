From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Re: hashsize available through /proc was RAM and conntrack
 performance: first draft of the document is online
Date: Thu, 27 Nov 2003 11:09:03 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311271102000.21649-100000@filer.marasystems.com>
References: <20031127041452.GD1084@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20031127041452.GD1084@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Herve Eychenne wrote:

> First I would have been happy to write a small patch, but I'm not really a
> kernel guy and register_sysctl_table API seems _completely crappy_ to
> me.

It is not that bad compared to the alternatives..

> So I took the risk to ridiculize myself in public and wrote something, though,
> but I'm unsure about my patch. Especially unsure about the Binary ID of
> the ctl_table... I took NET_IP_CONNTRACK_MAX + 1 = 2090 because I could find
> no occurence of 2090 user for sysctl in the whole kernel tree... but it
> seems crappy and hazardous. Who the hell is in charge of ensuring the
> unicity of each sysctl binary entry? Where's the list?

You also need to make the sysctl read-only.. you can not change the 
ip_conntrack hash size while conntrack is running. If you do there will be 
serious hazard.

Also what kernel version did you do this in? Your source does not seem to
match either 2.4.22 or 2.6.0-test10.. in the sources I see the conntrack
sysctls are all in ip_conntrack_standalone.c not ip_conntrack_core.c..
(looks like you got the filename wrong only..  the sources seem to match
ip_conntrack_standalone.c even if the header say 
ip_conntrack_core.c.new/orig)
