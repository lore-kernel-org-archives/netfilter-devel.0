From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] Make LOG targets log uid/gid
Date: Thu, 8 May 2003 11:20:29 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305081103470.23082@dns.toxicfilms.tv>
References: <Pine.LNX.4.51.0305072051330.18612@dns.toxicfilms.tv>
 <1052337904.23434.17.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1052337904.23434.17.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > This patch makes both of the LOG targets log uid and gid of a process
> > that owns the socket related to the sk_buff.
>
> Why not do somethine along the lines of
> http://www.netfilter.org/~gandalf/patches/ipt_LOG-uid.diff
Well, i made it to be an option, exactly the same as this patch.
But decided not to, because I thought I am approaching another
userspace/kernelspace incompatibilites between userspace/kernelspace
versions.
Btw, it is freaky to see exact same code written by someone else :)

> It doesn't really break compability, old userspace still works with the
> kernelpart patch
Yes, the masks will cover it smoothly.

> and new userspace still works without the kernelpart except that uid
> logging won't work (and ipt_LOG won't complain and the
> uid option is showed in print/save since ipt_LOG doesn't check
> IPT_LOG_MASK)
That would require including new ipt_LOG.h to
userspace/include/linux/netfilter_ipv4 to make compilation possible
with new IPT_LOG_UIDS option.

I will include these changes then and propose a new patch.

> /Martin
Maciej
