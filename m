From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Subject: Re: Parser stable fix question for CFG80211_INTERNAL_REGDB
Date: Tue, 1 Jul 2014 19:17:13 +0200
Message-ID: <20140701171713.GO27687@wotan.suse.de>
References: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com> <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com> <20140701144149.GB6358@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Felix Fietkau <nbd-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>, John Walker <john-40Xsf+s1Dzo@public.gmane.org>,
	Krishna Chaitanya <chaitanya.mgit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Richard Fontana <fontana-7LmRToLsLASJEOdND1YtKA@public.gmane.org>
To: "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140701144149.GB6358-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 01, 2014 at 10:41:49AM -0400, John W. Linville wrote:
> On Mon, Jun 30, 2014 at 12:19:08PM -0700, Luis R. Rodriguez wrote:
> > On Mon, Jun 30, 2014 at 11:55 AM, Luis R. Rodriguez
> > <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> wrote:
> > > For the current kernel we
> > > could intake the patch below, and I can port the change to no use
> > > dfs_cac, that would enable older kernels to use new and older versions
> > > of the ASCII database file.
> > 
> > Personally I actually rather avoid us accept a patch upstream for a
> > userspace change. The problem here is that we failed to realize the
> > impact of CFG80211_INTERNAL_REGDB at build time with a userspace tool,
> > in this case the db.txt file wireless-regdb provides and its format.
> > 
> > If we wanted to avoid a stable patch we could require a match between
> > wireless-regdb input file used for a kernel when
> > CFG80211_INTERNAL_REGDB is used at build time. That would require
> > different ASCII files on wireless-regdb or having the users of
> > CFG80211_INTERNAL_REGDB do the conversion themselves. Upstream would
> > just follow the wireless-regdb latest format. This then would just
> > require upstream a Kconfig update to clarify the requirements.
> > 
> > This seems like a rather lazy option but also one that would be rather
> > more fair and honest for upstream, we could deal with a proper fix by
> > reconsidering the implementation of CFG80211_INTERNAL_REGDB completely
> > for future kernels.
> 
> I'm shocked that anyone actually uses CFG80211_INTERNAL_REGDB...

I believe all mobile and APs use it these days.

> Anyway, I don't see the big deal.  We should keep
> CFG80211_INTERNAL_REGDB (whether implemented in awk or C) up-to-date
> with current kernels.  Anyone wanting to use an old kernel with an
> updated wireless-regdb file is responsible for ensuring compatibility.
> If they can't do that, then they should seek support from a vendor.

Fine by me... I'll update the Kconfig.

> How is this any different from any other kernel support issue?

This is a build issue that does not cause any errors, users go through with the install
just fine and only at run time do they discover the issue. We never documented
the expecations nor do I think we expected this before. This is also caused by an
input file from userspace, I do consider the issue unexpected.
 
  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
