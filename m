From: "yangrunhua" <yangrunhua@njupt.edu.cn>
Subject: RE: How to take over TCP connection from userspace process?
Date: Wed, 22 Oct 2003 11:44:56 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <006f01c3984e$e045fce0$d32f110a@yrhd>
References: <20031021134729.GB12049@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Harald Welte'" <laforge@netfilter.org>
In-Reply-To: <20031021134729.GB12049@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

But sendfile() system call could not support copying from socket to =
socket, and only transfer in one direction.

What I need is: after I authenticated TCP connection A(host A connected =
to me) and TCP connection B(host B connected to me), then let what host =
A send (through TCP connection A)directly forward to host B(through TCP =
connection B) in the kernel ,meanwhile, what host B send directly =
forward to host A in the kernel.

That's much like MSN Messenger Server's relaying webcam video stream =
between two peers after authenticated them. I want to do this relay in =
kernel space and auth in the userspace. It's much like NGN softswitch's =
theory: control and auth separate from transfer.

That's much useful functionality. Can netfilter/iptables help this? done =
this by writing a new target or something?

Thanks,
	Runhua Yang


-----Original Message-----
From: Harald Welte [mailto:laforge@netfilter.org]=20
Sent: Tuesday, October 21, 2003 9:47 PM
To: yangrunhua
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: How to take over TCP connection from userspace process?

On Tue, Oct 21, 2003 at 03:33:22PM +0800, yangrunhua wrote:
> Hi all,
> 	With the help of netfilter/iptables, is there any way to high-speed =
forwarding between 2 already-connected TCP connections in the kernel?

I don't see how this could be related to netfilter/iptables at all.
The normal sendfile() systemcall may be helpful to you.

> 	Thanks,
> 				Runhua Yang

--=20
- Harald Welte <laforge@netfilter.org>             =
http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
