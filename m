From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH 2.4] TCP window tracking: nf-log
Date: Sun, 4 Dec 2005 19:12:36 +0100
Message-ID: <20051204181236.GA6314@alpha.home.local>
References: <43819E46.4020603@tac.ch> <20051204135139.GA5570@alpha.home.local>
	<4393304C.2030100@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
Content-Disposition: inline
In-Reply-To: <4393304C.2030100@drugphish.ch>
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

Hi Roberto,

On Sun, Dec 04, 2005 at 07:07:08PM +0100, Roberto Nibali wrote:
> Hi Willy,
> 
> Thanks for your review.
> 
> > On Mon, Nov 21, 2005 at 11:15:34AM +0100, Roberto Nibali wrote:
> >> Hello,
> >>
> >> This is the rediffed nf-log patch against 2.4.32, which is needed in
> >> order to have the core tcp window tracking patch working in 2.4.x kernels.
> > 
> > I've fixed two things which prevented it from compiling :
> >   - removed a space change in ip_vs_conn.c which might have been caused
> >     by a change in your reference 2.4.32 tree ;
> 
> Hmm, I hopefully haven't included IPVS stuff into the nf-log patch, have
> I? I don't seem to be able to find this change in your proposal.

Here is the chunk I found in your patch and which I removed :

diff -Nur linux-2.4.32-orig/net/ipv4/ipvs/ip_vs_conn.c linux-2.4.32-pab2/net/ipv4/ipvs/ip_vs_conn.c
--- linux-2.4.32-orig/net/ipv4/ipvs/ip_vs_conn.c        2005-10-27 17:17:13 +0200
+++ linux-2.4.32-pab2/net/ipv4/ipvs/ip_vs_conn.c        2005-10-27 17:17:54 +0200
@@ -246,7 +246,7 @@
 struct ip_vs_conn *ip_vs_ct_in_get
 (int protocol, __u32 s_addr, __u16 s_port, __u32 d_addr, __u16 d_port)
 {
-       unsigned hash:
+       unsigned hash;
        struct ip_vs_conn *cp;
 
        hash = ip_vs_conn_hashkey(protocol, s_addr, s_port);

Just white spaces, but it was rejected. That's why I believe that your
reference tree has been touched.

> >   - ip6t_log_target() was not properly renamed as ip6t_log_packet(), so
> >     build was broken with IPv6 enabled.
> 
> I'll see to it, thanks. As you found out, I've never compiled my patches
> with IPv6 selected; thanks for checking it.
> 
> > Please use the attached one as an update.
> 
> I will, once I get some time again to work on the kernel.
> 
> > I'm still in the process of building a new kernel with all this, I'll keep
> > you informed.
> 
> Excellent.

Nearly ready to boot it :-)

> Have a nice evening,
> Roberto Nibali, ratz

Cheers,
Willy
