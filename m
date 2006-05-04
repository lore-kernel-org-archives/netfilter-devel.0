From: Holger Eitzenberger <holger@my-eitzenberger.de>
Subject: Re: conntrack sync via userspace ?
Date: Thu, 4 May 2006 17:34:59 +0200
Message-ID: <20060504153458.GA22463@kruemel.my-eitzenberger.de>
References: <1146691342.2360.51.camel@morannon.athome>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Arne Bernin <arne@alamut.de>
Content-Disposition: inline
In-Reply-To: <1146691342.2360.51.camel@morannon.athome>
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

On Wed, May 03, 2006 at 11:22:22PM +0200, Arne Bernin wrote:

> after playing a bit with ct_sync and finding out that it does not seems
> being actively developed i wonder whether it would be possible to do the
> syncing of conntrack tables over different machines using a user space
> daemon and libnfnetfilter_conntrack ? Is this a possible way , or a no
> go because of limitations in the conntrack lib , speed or something else
> i am not aware of ?
> I thought before digging to deep into it right now, i just ask the
> people who should know, sorry about my lazyness. ;-)

I am currently developing a version based upon libnfnetlink_conntrack,
which works great up until now.  My current version was planned as a
proof-of-concept initially but matured sinced I realized that this
will be working solution.  Of cource there are some performance
tradeoffs you have to make but this should be ok for most 
situations.

It uses libevent for IO multilpexing, which uses epoll() internally
on Linux.  But even select() wouldnt' be a problem because if usually
uses few file descriptors.

Open points are still overall configurability through a config file.

I will post an initial version in a few weeks.

/holger

-- 
ICQ 2882018 ++ Jabber: octavian@amessage.de ++
