From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: snat to multiple source ip
Date: Mon, 26 Sep 2005 18:39:13 +0200
Message-ID: <BAY103-DAV122786F84D83782AC7249B28B0@phx.gbl>
References: <BAY103-DAV93096D8E2EFC3B50E721DB28B0@phx.gbl>
	<20050926161049.GA16714@linuxace.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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


> On Mon, Sep 26, 2005 at 05:38:48PM +0200, Marco Berizzi wrote:
> > I would like to better understand the SNAT target when
> > multiple --to-source are specified.
>
> This capability has been removed from newer (2.6.11+) kernels,
> and was reported as being broken in kernels prioer to that.

Thanks for the reply. FYI tests were done with linux 2.4.31
Is there any other equivalent under 2.4 or 2.6?
