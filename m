From: Patrick Schaaf <bof@bof.de>
Subject: Re: target MARK in filter table?
Date: Sun, 13 Jul 2003 16:19:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030713141944.GB1284@oknodo.bof.de>
References: <Pine.LNX.3.95.1030713150116.17878A-100000@cannabis.dataforce.net> <Pine.LNX.3.95.1030713163717.31849A-100000@cannabis.dataforce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Poltorak Serguei <poltorak@df.ru>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.95.1030713163717.31849A-100000@cannabis.dataforce.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jul 13, 2003 at 04:43:13PM +0400, Poltorak Serguei wrote:
> 
> I tested MARK target with kernel without following line in linux/net/ipv4/netfilter/ipt_MARK.c
>         if (strcmp(tablename, "mangle") != 0) {
>                 printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n",
>                 return 0;
>         }
> 
> For now everything works including MARK target in chain INPUT of table filter.
> 
> If you do know a reason why this must not be done, please tell me. MARK is
> usefull even without advanced routing.

I do not disagree, the rerouting indecision was just the one possible reason
I could think of.

What do other developers think? What other reasons were there to keep the MARK
target from working in the filter table?

While we are on the topic of seemingly arbitrary "sanity" checks, why is
it that using the TCPMSS option throws a vague "invalid argument" error
when one forgets to also specify --syn? Can't that target just check for
tcp/syn dynamically, i.e. become a NOOP for non-syn packets, instead of
forcing me to specify --syn at rule insertion time?

best regards
  Patrick
