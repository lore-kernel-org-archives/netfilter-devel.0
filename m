From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Re: hashsize available through /proc was RAM and conntrack
 performance: first draft of the document is online
Date: Thu, 27 Nov 2003 12:57:02 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311271255290.24016-100000@filer.marasystems.com>
References: <20031127113815.GD1083@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20031127113815.GD1083@eychenne.org>
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

> I worked on 2.4.22 Debian kernel sources (patched), but in vanilla
> kernel 2.4.22, the files you're talking about are identical to the
> Debian sources (which contain only a few patches).
> And I maintain that my patch is against ip_conntrack_core.c...

Right.. my sources have current patch-o-matic applied.. 
80_ip_conntrack-proc.patch moves these to ip_conntrack_standalone.c

Regards
Henrik
