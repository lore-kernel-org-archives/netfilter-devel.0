From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: Including iptables.c in my C++ Project
Date: Thu, 3 Mar 2005 17:27:22 +0100 (CET)
Message-ID: <19442.213.236.112.75.1109867242.squirrel@213.236.112.75>
References: <1109865800.9270.17.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1109865800.9270.17.camel@localhost>
To: "Borja Pacheco" <bpacheco@acisa.es>
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

Borja Pacheco said:
> Dear all,
>
> I'm developing  a program in C++ which needs to insert rules into the
> kernel.
> I thought to invoke iptables binary directly, but I think that if I used
> it intensively it could be an issue with the performance, so I finally
> decided to include the source code of iptables into my own program and
> make internal calls to insert_entry (you can found its code into
> iptables.c) instead.

Better to use iptables-restore probably instead.

>
> To do this,
> I included into my files the following include:
> #include "iptables.c"

Aaargh. C and C++ are different languages. Also from an enginering point
of view this is a hack at best.

> /usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:297: error:
> pointer of
>    type `void *' used in arithmetic

This is different in C and C++.

> /usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:297: error:
> invalid
>    conversion from `void*' to `ipt_entry_target*'

As is this.

[ Lots of errors omitted ]

Read up on mixing C and C++ code. It's fairly trivial but this is not the
way to do it.

HTH,
M4
