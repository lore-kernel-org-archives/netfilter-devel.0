From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: TProxy w/2.6
Date: Mon, 21 Jun 2004 19:04:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621170452.GA6797@sch.bme.hu>
References: <54933.68.92.26.41.1087835494.squirrel@mercury.ddos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evan Langlois <evan@ddos.com>
Content-Disposition: inline
In-Reply-To: <54933.68.92.26.41.1087835494.squirrel@mercury.ddos.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Mon, Jun 21, 2004 at 11:31:34AM -0500, Evan Langlois wrote:
> I've been unable to get the TPROXY patch to patch against 2.6.5 ,2.6.6,
> nor 2.6.7.  I've tried the patches on the original authors site and the
> patches in patch-o-matic-ng.  The ones on the original authors site don't
> patch against a vanilla kernel of the version indicated.  I have no idea
> what kernel patches they already had installed to make that patch, or what
> its supposed to patch against.  I'd really prefer to use 2.6 for epoll.
> 
> Does anyone have any suggestions of where to go from here?

  Ask the right person! :)

  The patches on our homepage were created for 2.6.6 with Jozsef
Kadlecsik's TCP window tracking patch applied. The one in POM-ng should
apply on 2.6.6 (and probably fail on others). BTW, applying window
tracking onto 2.6.7 has failed for me, so applying TProxy will fail as
well.

  You can somewhat lower these requirements by skipping 04-nat_delete,
since that is a rarely-used optional part, and it is the only part of the
patches which requires the TCP window tracking code. I've just re-checked
that the patches contained in our tarball apply without rejects on vanilla
2.6.6.

--
 Regards, 
  KOVACS Krisztian
