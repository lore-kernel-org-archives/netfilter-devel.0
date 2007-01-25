From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: Re: rtsp conntrack compilation error 2.6.18
Date: Thu, 25 Jan 2007 17:37:55 +0100
Message-ID: <20070125163755.GA2356@ekonomika.be>
References: <loom.20061225T094953-80@post.gmane.org>
	<45A48342.1050601@trash.net> <1f7f01c73fd8$4ede0f10$c202010a@Fiona>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <1f7f01c73fd8$4ede0f10$c202010a@Fiona>
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

On Wed, Jan 24, 2007 at 05:54:13PM +0100, Sverker Abrahamsson wrote:
> I've been thinking many times to update the rtsp conntrack patch but where 
> can I find information about changes in the API (except for reading 
> diff's)? Are there any maintained API doc for netfilter?
> /Sverker

Some time ago I digged into the RTSP code to patch it so it would
compile without NAT. I have some notes on it that might be helpful:

http://www.singularity.be/node/6276

The result was mailed to this mailinglist in september:

http://lists.netfilter.org/pipermail/netfilter-devel/2006-September/025507.html

kind regards,
-- Steven

> 
> ----- Original Message ----- 
> From: "Patrick McHardy" <kaber@trash.net>
> To: "F Helmer" <netfilter.20.fhelmer@spamgourmet.com>
> Cc: <netfilter-devel@lists.netfilter.org>
> Sent: Wednesday, January 10, 2007 7:10 AM
> Subject: Re: rtsp conntrack compilation error 2.6.18
> 
> 
> >F Helmer wrote:
> >>Hello
> >>
> >>I am not sure if this is the correct group to post to?
> >>
> >>I am trying to patch my 2.6.18 kernel (latest pom using svn + runme 
> >>extra)
> >>and I
> >>get the following compilation error:
> >>
> >> CC [M]  net/ipv4/netfilter/ip_conntrack_netlink.o
> >> CC [M]  net/ipv4/netfilter/ip_conntrack_proto_sctp.o
> >> CC [M]  net/ipv4/netfilter/ip_conntrack_rtsp.o
> >>net/ipv4/netfilter/ip_conntrack_rtsp.c: In function 'help_out':
> >>net/ipv4/netfilter/ip_conntrack_rtsp.c:340: error: too few arguments
> >>to function
> >>'ip_conntrack_expect_alloc'
> >>net/ipv4/netfilter/ip_conntrack_rtsp.c:371: warning: implicit declaration 
> >>of
> >>function 'ip_conntrack_expect_free'
> >>make[4]: *** [net/ipv4/netfilter/ip_conntrack_rtsp.o] Error 1
> >>make[3]: *** [net/ipv4/netfilter] Error 2
> >>make[2]: *** [net/ipv4] Error 2
> >>make[1]: *** [net] Error 2
> >>make[1]: Leaving directory `/usr/src/linux-source-2.6.18'
> >>make: *** [debian/stamp-build-kernel] Error 2
> >>fredrikh@helmer:/usr/src/linux$
> >>
> >>Do you happen to know what I am doing wrong? Or is there a "better"
> >>patch somewhere?
> >
> >
> >The patch needs to be updated to work with current kernels. Its
> >not actively maintained, so you'll probably have to do it yourself.
> >
> >
> >
> 

-- 
My amazon wishlist:
http://www.amazon.com/gp/registry/1DB4XNEIEQBPB

"Remember, there are those who complain, and there are those who solve problems. 
 The problem-solvers are called "engineers"?so go ahead and be one, even if the 
 problem and its solution are relatively unsophisticated!" -- planetanalog.com
