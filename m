From: Phil Oester <kernel@linuxace.com>
Subject: Re: snat to multiple source ip
Date: Mon, 26 Sep 2005 10:47:28 -0700
Message-ID: <20050926174728.GA17007@linuxace.com>
References: <BAY103-DAV93096D8E2EFC3B50E721DB28B0@phx.gbl>
	<20050926161049.GA16714@linuxace.com>
	<BAY103-DAV122786F84D83782AC7249B28B0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
Content-Disposition: inline
In-Reply-To: <BAY103-DAV122786F84D83782AC7249B28B0@phx.gbl>
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

On Mon, Sep 26, 2005 at 06:39:13PM +0200, Marco Berizzi wrote:
> > On Mon, Sep 26, 2005 at 05:38:48PM +0200, Marco Berizzi wrote:
> > > I would like to better understand the SNAT target when
> > > multiple --to-source are specified.
> >
> > This capability has been removed from newer (2.6.11+) kernels,
> > and was reported as being broken in kernels prior to that.
> 
> Thanks for the reply. FYI tests were done with linux 2.4.31
> Is there any other equivalent under 2.4 or 2.6?

You could try the random match from pom, but to do this without
patching the kernel, probably could use multiple -s rules:

-s 10.0.0.0/24 -j SNAT x.x.x.x
-s 10.1.0.0/24 -j SNAT y.y.y.y

or somesuch.

Phil
