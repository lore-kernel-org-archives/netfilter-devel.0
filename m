From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: 2.4.22-pre9 and pending patches issues
Date: Wed, 30 Jul 2003 09:36:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.52.0307300933570.27087@tux.rsn.bth.se>
References: <3F27723B.7040502@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <3F27723B.7040502@tac.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jul 2003, Roberto Nibali wrote:

> Hi,
>
> Sorry if this is a no-brainer but I have not been able to apply
> 57_conntrack-tcp-nopickup.patch to the newest 2.4.22-pre9 kernel. Does anyone
> have a quick solution or do I have to merge manually? 39_ip_conntrack-proc.patch
> 40_nf-log.patch 54_ip_nat-macro-args.patch 55_ipt_unclean-tcp-flag-table.patch,
> all to apply more or less cleanly to the newest drop.
>
> Also the tcp-window-tracking patch is not applicable to this kernel. I reckon
> this is because 57_* doesn't apply. I haven't looked further into this.

I'll look into it tonight.

When stuff like this happens it's usually because of another change in
that kernel that modified a file we also want to modify. It's a major
pain when that happens since it makes it harder to support both older
kernels and newer kernels with the same patch.

/Martin
