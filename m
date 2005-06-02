From: Hadrien HAMEL <hamel@enseirb.fr>
Subject: Re: Writing new Netfilter Modules
Date: Thu, 02 Jun 2005 19:17:31 +0200
Message-ID: <429F3F2B.6090406@enseirb.fr>
References: <6B6D4D4E2ED1D6119DB80000D11D813EB4CA6F@blns203e.bln.icn.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <6B6D4D4E2ED1D6119DB80000D11D813EB4CA6F@blns203e.bln.icn.siemens.de>
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

Gingold Tomasz wrote:

>Hello,
>
>i want to write my own netfilter module. Can anybody tell me how to star=
t?
>Are there any tutorials/documents which could help?
>
>Up to now i have found the "Linux netfilter Hacking HOWTO", especially
>chapter 4 "Information for Programmers.
>Is this the only help i can obtain?
>
>
>Another question:=20
>I have found on www.netfilter.org <www.netfilter.org>  the following sta=
tement:=20
>"netfilter and iptables are building blocks of a framework inside the Li=
nux <http://www.kernel.org/>  2.4.x and 2.6.x kernel"
>Does this mean, that netfilter and iptables are part of the kernel and d=
on=B4t have to be installed?
>
>thanks for helping
>gingold tomasz
>berlin
>
>
> =20
>

Hi,

There's a step-by-step description about writing a "match" extension here=
:

http://www.linuxfocus.org/English/February2005/article367.shtml


I'm planning on writing another tutorial to help people developping
extensions for NetFilter :)
If you have any suggestions, send them to me!

--
Hadrien Hamel
French engineer
