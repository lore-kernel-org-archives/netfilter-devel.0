From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: "unclean" ?bug? with dell dns
Date: Mon, 9 Sep 2002 22:40:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209092237510.2819-100000@blackhole.kfki.hu>
References: <200209091948.1734@ellinger.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Guillaume Morin <guillaume@morinfr.org>,
	Yannick Le Saint <y.lesaint@free.fr>,
	<netfilter@lists.netfilter.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rainer Ellinger <rainer@ellinger.de>
In-Reply-To: <200209091948.1734@ellinger.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 9 Sep 2002, Rainer Ellinger wrote:

> Guillaume Morin wrote:
> > >  When i "dig www.euro.dell.com", i get in syslog :
> > I'd say that unclean matches the packet because of a checksum
> > mismatch. There must be a buggy router between you and the server.
>
> I ran into the same problem and can also confirm that this is a problem
> with dell's nameserver or a system on dell's side. Further
> investigation with ethereal showed that matching pakets had their udp
> crc set to 0x0000. My questions are:
>
> Should this condition really considered harmful and matched by unclean?

I don't think so. UDP checksumming is not mandatory, but the unclean
module accepts only packets with valid checksums.

> Why is there no corresponding log message from the unclean module?

Because the unclean module does not log packets with invalid checksums.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
