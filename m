From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Illegal option `-i' with conntrack -I
Date: Thu, 3 Nov 2005 15:23:47 +0100
Message-ID: <200511031523.48170@nienna>
References: <Pine.LNX.4.63.0511031427190.1341@bizon.gios.gov.pl>
	<200511031507.52812@nienna>
	<Pine.LNX.4.63.0511031510130.4331@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.63.0511031510130.4331@bizon.gios.gov.pl>
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

On Thursday 03 November 2005 15.12, Krzysztof Oledzki wrote:
> > On Thursday 03 November 2005 14.36, Krzysztof Oledzki wrote:
> >> It seems it is not possible to specify conntrack id while adding
> >> new conntrack. Is it intentionally?
> >
> >  I guess it's intentional. For the netlink dump to work you need
> > the IDs of conntrack entries to be unique and monotonously
> > increasing, and that's what setting the ID from userspace could
> > ruin.
>
> So netlink will never allow to save & restore exact status of
> the ip_conntrack?

  Apart from the netlink interface nothing uses the ID, so obviously 
there's no way it could have any influence on connection tracking or 
packet classification. But then what's the point in restoring it?

-- 
 Regards,
  Krisztian Kovacs
