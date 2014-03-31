From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 2/2] netfilter: xt_nfacct: Add quota to nfacct filter
Date: Mon, 31 Mar 2014 17:17:30 +0200
Message-ID: <20140331151730.GA19050@localhost>
References: <1396213844-10528-1-git-send-email-mathieu.poirier@linaro.org>
 <1396213844-10528-3-git-send-email-mathieu.poirier@linaro.org>
 <20140331121351.GA3866@localhost>
 <CANLsYky5ciqKEP7oNuP1bEdX3iARKHtDgv=87j8dFXjTCt255Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANLsYky5ciqKEP7oNuP1bEdX3iARKHtDgv=87j8dFXjTCt255Q@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 31, 2014 at 07:50:06AM -0600, Mathieu Poirier wrote:
[...]
> >
> > You can just define some enum, ie.
> >
> > enum {
> >         NFACCT_NO_QUOTA         = -1,
> >         NFACCT_UNDERQUOTA,
> >         NFACCT_OVERQUOTA,
> > };
> >
> > to include/linux/netfilter/nfnetlink_acct.h.
> >
> > I guess with that we can also remove the comments everywhere, as it
> > will be quite clear with the enums.
> >
> > Merge window will be close soon, please also post the userspace
> > changes for the library and the utility asap.
> 
> At this time I only have the userspace modifications in the nfacct
> port I did for Android.  That one links to libnl2.0 and won't be of
> interest to you.  I can get you the kernel work in time for the merge
> window but modifications to the "real" nfacct may not make it.  I'd
> love to see the work going in the 3.15 merge window but can't offer
> guarantees.
> 
> Would you consider queuing the kernel patch in the merge window
> without the userspace?  Note that I would understand if you woudn't
> accept that....

You have to send me the library changes for libnetfilter_acct at
least and the tested kernel patch asap.
