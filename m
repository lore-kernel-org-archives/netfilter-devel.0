From: Poltorak Serguei <poltorak@df.ru>
Subject: Re: target MARK in filter table?
Date: Sun, 13 Jul 2003 15:19:42 +0400 (MSD)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.3.95.1030713150116.17878A-100000@cannabis.dataforce.net>
References: <20030713070203.GA1284@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030713070203.GA1284@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

;Traditional counterquestion: what do you want to accomplish, that lets
;you look for MARK in filter?
I yould like to mark packets that passes through several chains. I don't
want allow packets there, I want them to continue their live (to be DROPed :)
This has nothing to do with routing, i'm using iproute without fwmark.
And after all in mangle table there are chains placed after routing. so
what about using mangle in a chain like that?

MAy be u know another way to mark packets. For me it's only a flag that
packets have when the pass a chain.

A had a look in iptables: iptables doesn't check the table for MARK target.
In kernel source there are only one check that does nothing (except check :)
        if (strcmp(tablename, "mangle") != 0) {
                printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n",
                return 0;
        }
may be that will suffice

thanks for help

PoltoS/
