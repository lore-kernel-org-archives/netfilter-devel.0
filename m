From: Ilguiz Latypov <ilguiz@nit.ca>
Subject: Re: [PATCH] PPTP conntrack enhancements
Date: Wed, 4 Dec 2002 06:17:39 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212040606320.21660-100000@localhost.localdomain>
References: <3DEC4A99.9090805@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <3DEC4A99.9090805@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Philip,

The updated patch works fine with my tests.

I still get GRE write errors in PoPToP server but they could happen due to
many other reasons.  E.g., the file descriptor set the daemon monitored
was never cleared in the beginning of each loop.

I had to add the following line to the bottom of ip_conntrack_proto_gre.c
in order to avoid an insmod error when loading ip_conntrack_pptp.o.  The
error message informed that the ip_ct_gre_keymap_destroy symbol could not
be found.

    EXPORT_SYMBOL(ip_ct_gre_keymap_destroy);

Many thanks for the PPTP conntrack corrections.

--
Ilguiz Latypov
Net Integration Technologies, Inc

tel. +1 (514) 281 9191 x 117

On Tue, 3 Dec 2002, Philip Craig wrote:

> I've attached a diff against the PPTP conntrack patch to fix
> various issues.  The major changes are that it now works in
> the presence of DNAT, and uses GRE expectations in both
> directions.
