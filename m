From: Markus Schaber <markus.schaber@student.uni-ulm.de>
Subject: Re: Easy question, how to use stdio.h
Date: Tue, 22 Apr 2003 19:05:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030422190527.400dcc77.markus.schaber@student.uni-ulm.de>
References: <e3f7fde643.de643e3f7f@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "ISLERO77@telefonica.net" <ISLERO77@telefonica.net>
In-Reply-To: <e3f7fde643.de643e3f7f@teleline.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hallo,

"ISLERO77@telefonica.net" <ISLERO77@telefonica.net> schrieb:

> Maybe my question is very easy, but I'm new developing in Linux. =20
> I'm trying to use fopen, fprintf and fclose in a match, so I'm
> writting   #include <stdio.h> =20
> but when I compile the kernel and I do  =20
> make modules =20
> the system doesn't recognize any of these functions =20
> How can I use them??? =20

Basically, you can't.

As matches are kernel modules, they run in kernel space. They don't have
the usual application infrastructure (as it is the kernel's task to
provide the fundament of this infrastructure, and the libc's task to
provide the rest.)

Maybe you could tell us what you want to achieve, so we can possibly
tell you how to do it.


Gru=DF,
Markus

--=20
Schabi's Flohmarkt: http://schabi.de/flohmarkt/

Der Dienstweg ist die Verbindung der Sackgasse mit dem Holzweg!
[DoLi in unibwm.studium]
