From: Kenneth =?iso-8859-1?q?Aafl=F8y?= <keaafloy@online.no>
Subject: Re: 2.6.6-rc3 - "ip_conntrack_in: Frag of proto 17" (udp) with kNFS r/wsize > 8192
Date: Sat, 8 May 2004 23:19:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405082319.40620.keaafloy@online.no>
References: <200405070411.48918.keaafloy@online.no> <Pine.LNX.4.58.0405071226130.13178@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0405071226130.13178@tux.rsn.bth.se>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 07 May 2004 12:30, Martin Josefsson wrote:
> On Fri, 7 May 2004, Kenneth Aafl=F8y wrote:
> > I've come across some strange behavior with a nfs server running on
> > 2.6.6-rc3 today.
[snip]
> > NFS server not responding, still trying. NFS server OK.
[snip]
> Could you test this patch? If it triggers we know that we still have
> fragmented packets after defrag, which we shouldn't.

This patch does not trigger any suspicious behaviour. I also have done some=
=20
additional testing (must have been half asleep last time), and I've found=20
that I only end up in the "ip_conntrack_in: Frag of proto %u" code if I mou=
nt=20
a nfs share locally, and that this local share will stall completly if the=
=20
conntrack module is loaded. If I mount the share from a remote client, it=20
will work just fine. Is this a bug or just me doing to little reading?

About the slowness of NFS from remote clients, this is just because the=20
default r/wsize is to high for the wireless card I was using. Sorry for not=
=20
checking more thoroughly and not reading the HOWTOs!

Kenneth
