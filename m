From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Roadmap for IPv6 stateful filtering
Date: Tue, 8 Nov 2005 15:02:03 +0100
Message-ID: <200511081502.04272@nienna>
References: <436FBCDF.4060900@net.in.tum.de> <4370A4A3.20702@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Gregor Maier <gregor@net.in.tum.de>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4370A4A3.20702@eurodev.net>
Content-Disposition: inline
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


  Hi,

On Tuesday 08 November 2005 14.14, Pablo Neira wrote:
> Gregor Maier wrote:
> > I just wanted to ask if there is any roadmap or a plan when (if at all)
> > stateful filtering (and maybe connection tracking) for IPv6 will be
> > available in netfilter.
> > I found a page that claimed that stateful IPv6 filtering will be
> > available in the 2.6.15 kernel release (unfortunaly I misplaced the
> > link to the page somewhere :-(  ). Is this info correct? Or is there
> > another kernel version targeted?
>
> nf_conntrack got pushed forward to 2.6.15, so you'll have that feature
> in the next release candidate.

  Unfortunately I'm not quite sure about that... It's not yet in Linus' tree 
and it did not made it into Arnaldo's net-2.6 tree either. Maybe Harald has 
more information about it, but it seems quite a bit uncertain whether or 
not it will be merged in 2.6.15...

-- 
 Regards,
  Krisztian Kovacs
