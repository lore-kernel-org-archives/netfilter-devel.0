From: Steve Davies <davies147@gmail.com>
Subject: Re: SIP/RTP support coming?
Date: Fri, 15 Apr 2005 09:44:03 +0100
Message-ID: <5caa9b870504150144bc47d62@mail.gmail.com>
References: <5caa9b8705021203527b3891d@mail.gmail.com>
	<20050212120847.GA30461@roonstrasse.net>
	<1108238199.1183.11.camel@www.l-chr.com.ar>
Reply-To: Steve Davies <davies147@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel2@arnet.com.ar>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <1108238199.1183.11.camel@www.l-chr.com.ar>
Content-Disposition: inline
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

Christian,

Sorry about taking so long to get back to you - I have been using your
SIP conntrack helper for a little while now, and it seems to work very
well for me, also with kernel 2.6.10.

Many thanks for providing it.

One small problem I do have is the netfilter API change in kernel
2.6.11 - Is this change documented anywhere? Is there a
porting/updating guide anywhere?

Thanks,
Steve

On 2/12/05, Christian Hentschel <chentschel2@arnet.com.ar> wrote:
> Hi, i'm very interesting in a conntrack/nat helper for sip.
> Currently i'm working on this and help with testing will be great.
> i've used kernel 2.6.10 for this.
>=20
> Christian.
>=20
> On Sat, 2005-02-12 at 13:08 +0100, Max Kellermann wrote:
> > On 2005/02/12 12:52, Steve Davies <davies147@gmail.com> wrote:
> > > Are there plans to integrate this officially? Should I take time to
> > > (try to) update the patch to the 2.6.x kernel? Am I missing
> > > something?
> >
> > I believe nobody is working on that yet; I planned to look at the code
> > when I'm done with the H.323 module, but that will take some time.
> >
> > A lot people would be thankful if you hacked the source, and ported
> > that to Linux 2.6.11-rc3 (the API has changed very much since 2.6.10;
> > don't use the old API).
> >
> > You should start with providing a patch-o-matic module (see netfilter
> > home page) of the original code, and then send patches with your
> > changes.
> >
> > Max
> >
> >
> --
>=20
>=20
>
