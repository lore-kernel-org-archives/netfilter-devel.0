From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: conntrack for multiple interfaces
Date: Tue, 17 Jan 2006 13:19:50 +0100
Message-ID: <200601171319.51023@nienna>
References: <200601161355.22867.kgy@deverto.com>
	<1137488128.5084.5.camel@bzorp.balabit> <43CCD97D.80800@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Kovesdi Gyorgy <kgy@deverto.com>, Balazs Scheidler <bazsi@balabit.hu>,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <43CCD97D.80800@gmx.net>
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

On Tuesday 17 January 2006 12.48, Carl-Daniel Hailfinger wrote:
> > Conntrack is interface independent, however it does not handle when
> > tuples collide, it assumes they are part of the same connection. (ie.
> > it does not work, unless your IP space is actually divided between
> > interfaces and connections never collide)

  Yes, but current mode of operation does work in most cases.

> That's unfortunate. IIRC someone posted a patch to netfilter-devel half
> a year ago (sorry, no exact date) to address that issue. Was there some
> reason not to include it back then?
> The only problem with that patch I can think of right now would be load
> balancing over multiple links.

  Apart from breaking a couple of scenarios, what would be the advantage of 
differentiating connections per interface?

-- 
 Regards,
  Krisztian Kovacs
