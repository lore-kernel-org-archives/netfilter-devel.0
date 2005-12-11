From: Bryan Cardillo <dillo+netfilter@seas.upenn.edu>
Subject: Re: ipt_recent needs a maintainer!
Date: Sun, 11 Dec 2005 11:59:24 -0500
Message-ID: <20051211165924.GA3144@rover.pcbi.upenn.edu>
References: <20051209051254.GH4244@rama.exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20051209051254.GH4244@rama.exocore.com>
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

On Fri, Dec 09, 2005 at 10:42:54AM +0530, Harald Welte wrote:
> ipt_recent was merged into the mainline kernel quite some time ago, but
> unfortunately the original author doesn't seem to be compelled to
> maintain it.  There's nothing wrong with that, after all we do this
> voluntarily!  But we have to deal with the consequences.
> 
> Some people from the netfilter community have indicated that it's coding
> style rectifies a re-write, but that's something I don't want to address
> now.
> 
> What we need as a short-term solution is somebody maintaining this
> beast, somebody looking into bug reports, etc.
> 
> There are a number of bug reports coming in, and nobody really takes
> care of them.  The latest one seems to be
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=415
> but there are more, like
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=369
> and I also think there have been reports to bugme.osdl.org as well.
> 
> Unless somebody volunteers to maintain that module within a short time,
> I suggest that we mark it as "EXPERIMENTAL" and/or "BROKEN" in Kconfig
> of 2.6.16.

        if nobody more qualified steps up, I'd be happy to maintain
        it.  it is similar (sort of) to the expire module which I
        hacked up (and is also of questionable usefulness).  it will
        probably be a week or so before I can look at the code and
        reported bugs.  so if others beat me to patches, rewrites,
        etc, great, but I just wanted to register my interest.

        --Bryan
