From: Poltorak Serguei <poltorak@df.ru>
Subject: Re: target MARK in filter table?
Date: Sun, 13 Jul 2003 16:43:13 +0400 (MSD)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.3.95.1030713163717.31849A-100000@cannabis.dataforce.net>
References: <Pine.LNX.3.95.1030713150116.17878A-100000@cannabis.dataforce.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.3.95.1030713150116.17878A-100000@cannabis.dataforce.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I tested MARK target with kernel without following line in linux/net/ipv4/netfilter/ipt_MARK.c
        if (strcmp(tablename, "mangle") != 0) {
                printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n",
                return 0;
        }

For now everything works including MARK target in chain INPUT of table filter.

If you do know a reason why this must not be done, please tell me. MARK is
usefull even without advanced routing.

PoltoS/
