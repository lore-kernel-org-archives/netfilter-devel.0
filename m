From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Fw: state of play for TCP-window-tracking patch
Date: Fri, 14 Nov 2003 19:20:18 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <014d01c3aa88$23682d90$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks Jozsef,

 Any idea as to when your new port maybe available for us to start testing
with 2.6? We're currently doing operational and performance testing on 2.6
now.

 Thanks,
Andrew.

> ----- Original Message -----
> From: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
> To: "Andrew Hall" <temp02@bluereef.com.au>
> Cc: <netfilter-devel@lists.netfilter.org>
> Sent: Friday, November 14, 2003 6:59 PM
> Subject: Re: state of play for TCP-window-tracking patch
>
>
> > On Fri, 14 Nov 2003, Andrew Hall wrote:
> >
> > > Can someone please inform me of the current status of the
> > > tcp-window-tracking patch, particularly in reference to it's
> compatibility
> > > or eligibility for inclusion into the 2.6 stream? I have tried to do a
> > > direct port from the last 2.4 version but quite a bit has seemed to
have
> > > changed in the skbuff function definitions for 2.6. I'd be interested
in
> > > helping to port it if this was the intention as the stock 2.6.0-test 9
> > > implementation of the TCP state stuff seems to be the old 2.4 stuff.
BTW
> > > does anyone have any documentation as to what the fundamental changes
> have
> > > been to the net components of 2.6 over 2.4?
> >
> > With the incredible amount of testing/bug-hunting/code snippets by Willy
> > Tarreau the tcp-window-tracking patch evolved silently very much in the
> > last few weeks.
> >
> > There were so many changes that I'm delaying the release of the new
code;
> > cleaning up and final testings are required. The port to 2.6 is ready.
> >
> > According to the netfilter developer workshop, the TCP window tracking
> > code will be submitted into both the 2.4 and 2.6 series, with disabled
> > window tracking in 2.4 from backward compatibility reasons.
> >
> > Best regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : KFKI Research Institute for Particle and Nuclear Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
> >
> >
> >
> >
>
