From: "Hillmann, Oliver" <Oliver.Hillmann@charite.de>
Subject: Re: ICMP unreachable (DF) does not report the NATed IP
Date: Mon, 12 May 2003 14:10:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4F9AFAF72B246745B6847C7EECD8FF6901D17A88@EXCHANGE1.charite.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Netfilter-devel" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> -----Original Message-----
> From: Harald Welte [mailto:laforge@netfilter.org]
> Date: Dienstag, 29. April 2003 16:51
> To: Martin Josefsson
> Cc: Hillmann, Oliver; Netfilter-devel
> Subject: Re: ICMP unreachable (DF) does not report the NATed IP
> [..]
> please don't tell me there is still an unhandled ICMP reply=20
> translation
> problem.  If yes, I think I need a new brain.

The good news is that you can happily keep your brain, the
11_inner-icmp-translation-fix fully fixed my problem. (That's why I
originally sent my message to the netfilter-users list because something
made me think this might have been an issue somebody has seen before and
there is no need to bother the developers, rather need to find the right
patch or documentation ;)

> > I've havn't given it much thought yet.
> >=20
> > Also look at the=20
> submitted/11_inner-icmp-translation-fix.patch patch in
> > patch-o-matic as it modifies this function.

Thanks, works perfectly (and still I am amazed by the small number of
lines changed to fix this).

Regards,

Oliver
