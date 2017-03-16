From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 0/7] net, netfilter refcounter conversions
Date: Thu, 16 Mar 2017 07:52:19 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C59A26@IRSMSX102.ger.corp.intel.com>
References: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
 <20170315130213.GA30233@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170315130213.GA30233@salvia>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> On Wed, Mar 15, 2017 at 01:10:38PM +0200, Elena Reshetova wrote:
> > This series, for the netfilter subsystem, replaces atomic_t reference
> > counters with the new refcount_t type and API (see include/linux/refcou=
nt.h).
> > By doing this we prevent intentional or accidental
> > underflows or overflows that can led to use-after-free vulnerabilities.
> >
> > Please take the series to your tree if there are no run-time issues.
>=20
> Could you collapse all of your patches into one single? They are all
> part of the same logical change to me.
>=20
> >  21 files changed, 85 insertions(+), 75 deletions(-)
>=20
> The diffstat is small enough to do what I'm asking.

Sure. The reason why they are separated is that it is easier to review them=
 this way IMO and find mistakes (I found many after I split all networking =
patches into one per variable).
But I guess for merge, it is easier to have them collapsed, so I am going t=
o send you a new version shortly.=20

Best Regards,
Elena.

>=20
> Thanks!
