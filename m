From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables] extensions: add support for 'srh' match
Date: Thu, 11 Jan 2018 13:17:44 +0100
Message-ID: <20180111121744.5msbbjop4yvtn7ni@salvia>
References: <1514545705-13868-1-git-send-email-amsalam20@gmail.com>
 <20180110153224.3qtwicyu3sjzu2ec@salvia>
 <20180111111452.2ace1cdde68b3a11a2144a00@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
To: Ahmed Abdelsalam <amsalam20@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111111452.2ace1cdde68b3a11a2144a00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 11, 2018 at 11:14:52AM +0100, Ahmed Abdelsalam wrote:
> On Wed, 10 Jan 2018 16:32:24 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Fri, Dec 29, 2017 at 12:08:25PM +0100, Ahmed Abdelsalam wrote:
> > > This patch adds a new exetension to iptables to supprt 'srh' match
> > > The implementation considers revision 7 of the SRH draft.
> > > https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07
> > > 
> > > Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
> > > ---
> > >  extensions/libip6t_srh.c                | 283 ++++++++++++++++++++++++++++++++
> > >  include/linux/netfilter_ipv6/ip6t_srh.h |  63 +++++++
> > 
> > Please, add a extensions/libip6t_srh.t test file and send a v2.
> > 
> > Thanks.
> Ok, 
> Is there minimum requirements of the test cases to be added to the extensions/libip6t_srh.t file ?

I leave it up to you to decide what level of coverage you consider is
good to make sure that future changes don't break your new feature.

Thanks!
