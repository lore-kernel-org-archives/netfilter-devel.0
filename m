From: Russell Miller <rmiller@duskglow.com>
Subject: Re: QUEUE, large udp message failure
Date: Thu, 6 May 2004 15:28:09 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405061528.16034.rmiller@duskglow.com>
References: <20040506194525.38183.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040506194525.38183.qmail@web13907.mail.yahoo.com>
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

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thursday 06 May 2004 14:45, Scott MacKay wrote:

> Where PACKET_SIZE_MAX is 64000.  I have a normal
> ipq_read() loop using the readBuffer and it normally
> works fine, allowing me to do my stuff with the
> packet.
> The problem comes in when I get a large message
> (tested was 24000 bytes).  ipq_read fails.  I added
> some debug and it seems to be in
> ipq_netlink_recvfrom() where the recvfrom() fails with
> errno=3D105.  Is there some artifical cap on the size of
> a message which can be passed to the QUEUE target?
>
Don't know if this helps, but:

The payload size can be as high as 65536 bytes.  If your buffer is not larg=
e=20
enough to receive the payload, ipq_read will return with ENOBUFS, which mea=
ns=20
your buffer is not large enough.  I bet if you set PACKET_SIZE_MAX to 65536=
,=20
that problem goes away.

=2D --Russell

> -Scott
>
>
>
>
>
>
>
>
> __________________________________
> Do you Yahoo!?
> Win a $20,000 Career Makeover at Yahoo! HotJobs
> http://hotjobs.sweepstakes.yahoo.com/careermakeover

=2D --=20

Russell Miller - rmiller@duskglow.com - Somewhere near Sioux City, IA.
Youth cannot know age, but age is guilty if it forgets youth
    - Professor Dumbledore
Hi! I'm a .signature virus! Copy me into your ~/.signature, please!
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAmp/cURTA4VCI9OARAtGgAJ40xCgkuud9kk/kckX9P8xQVFaQKgCeKCQ2
Pfb+kY6GjEFYoepess6CK98=3D
=3D2Hhi
=2D----END PGP SIGNATURE-----
