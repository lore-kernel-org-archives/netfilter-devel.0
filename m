From: Philippe Biondi <biondi@cartel-securite.fr>
Subject: Re: ICMP DNAT bug fix no longer applies?
Date: Thu, 24 Apr 2003 15:42:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304241539121.12543-100000@deneb.intranet.cartel-securite.net>
References: <Pine.LNX.4.44.0304241412470.24242-100000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.44.0304241412470.24242-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all!

On Thu, 24 Apr 2003, Chris Wilson wrote:

> Does anyone know why the DNAT bug fix hasn't been incorporated into
> the main codebase yet?

AFAIK, this patch was too intrusive into the IP layer of the linux kernel
to be included.

But I've seen this some times ago :

Summary of changes from v2.4.21-pre5 to v2.4.21-pre6
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[...]

<laforge@netfilter.org>:
  o [NETFILTER]: fix NAT ICMP reply translation of inner packet
[...]


I see that as the so long waited fix. Harald, do you confirm that ?



--=20
Philippe Biondi <biondi@ cartel-securite.fr> Cartel S=E9curit=E9
Security Consultant/R&D                      http://www.cartel-securite.f=
r
Phone: +33 1 44 06 97 94                     Fax: +33 1 44 06 97 99
PGP KeyID:3D9A43E2  FingerPrint:C40A772533730E39330DC0985EE8FF5F3D9A43E2
