From: Nils Ohlmeier <lists@ohlmeier.de>
Subject: Re: Session Initiation Protocol
Date: Fri, 6 Sep 2002 15:54:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200209061554.01010.lists@ohlmeier.de>
References: <200209051525.44011.calum.sep02@umtstrial.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200209051525.44011.calum.sep02@umtstrial.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Calum,

i'm not speaking for the netfilter team but i'm also working in a lab whi=
ch=20
deals with SIP.

On Thursday 05 September 2002 16:25, Calum wrote:
> With SIP soon to be huge, especially with 3G phones, is there any work
> underway to make a sip_masq module, a la FTP, or IRC?

As far as i know: no.=20
Search the mailinglist for previous discussions about this topic.
Maybe http://fcpd.berlios.de as an application level gateway approach is=20
inetresting for you.

> I work in a test lab where we deal with SIP, and would be willing to he=
lp
> out if testing were needed. (tcpdump captures, etc)

If you work in a test lab, you should be aware of the problems:=20
- domain names in the protocol
- encryption is possible and makes NAT impossible
- masquerading the initiation protocol is not enough, because you also ha=
ve to=20
masquerade the content protocols (which ever this will be; RTP in most=20
cases).

> Here is the SIP RFC.
> (I cursed them when I found out that it didn't work through NAT. Althou=
gh,
> with IPv6, we might not need it as much)
> http://www.ietf.org/rfc/rfc2543.txt

RFC3261 (http://www.ietf.org/rfc/rfc3261.txt?number=3D3261) makes RFS2543=
=20
obsolete.

Regards
   Nils Ohlmeier
