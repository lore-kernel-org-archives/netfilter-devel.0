From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP tracking states
Date: Tue, 9 Jul 2002 13:18:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0207091257050.2809-100000@blackhole.kfki.hu>
References: <200207060038.59577@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200207060038.59577@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 6 Jul 2002, Henrik Nordstrom wrote:

> The recent discussions and Oskar Andreassons work on a iptables
> tutorial made me take a closer look into the TCP tracking states, and
> I notices a couple of odd things that looks like they may be bugs..
>
> 1. What is the use of LAST_ACK? From what I can tell this state can
> only be reached if the connection is already in the LAST_ACK state..
>
> 2. The support for half-closed connections is very poor, and differs a
> lot depending on which side closed first.

[...]

Yes, those are inconsystencies.

Could you have a look at the tcp_window_tracking patch? I spent a couple
of time on refining the state transitions in that patch, still there
might be room to improve them...

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
