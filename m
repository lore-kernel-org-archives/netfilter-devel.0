From: Ilguiz Latypov <ilguiz@nit.ca>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Fri, 11 Apr 2003 07:09:57 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304110659110.12367-100000@localhost.localdomain>
References: <3E969D88.4070005@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3E969D88.4070005@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Fri, 11 Apr 2003, Friedrich Lobenstock wrote:

> > If you remove the comment and include the line "return NF_ACCEPT",
> > then any packet with an invalid checksum is NOT processed by the PPTP
> > helper function. With the line commented out the incorrect checksum is
> > ignored and the packet is processed by the rest of the PPTP helper
> > function. Why this solved your problem I can't say.
>
> I don't know either. Because of this I ask the author of this module to
> make this an option to the module, so I do not have to create two
> different versions of devil linux to support both possibilities.

Are you connecting to the Windows server from the Linux machine where PPTP
connection tracking modules are loaded?

If this is true, you would be affected by the modules' rewriting of call
IDs in one direction only when you were running the unmodified version.

To be able to connect from such Linux machine to another PPTP server, you
need to apply the pending local NAT patch from the netfilter patch-o-matic
and enable the CONFIG_NF_NAT_LOCAL option in the kernel.

There would be nothing Windows specific in this case.

Correct me if I am wrong.

--
Ilguiz Latypov
Net Integration Technologies, Inc

tel. +1 (514) 281 9191 x 117
