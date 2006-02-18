From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both
 incoming and outgoing packets
Date: Sat, 18 Feb 2006 20:28:49 +0100
Message-ID: <43F77571.7020100@trash.net>
References: <200602181420.02791.edwin@gurde.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932125AbWBRTaW@vger.kernel.org>
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwin@gurde.com>
In-Reply-To: <200602181420.02791.edwin@gurde.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

T=F6r=F6k Edwin wrote:
> First of all this is what I'd like to achieve:
> - filter packets by the program who sent the packet
> - filter packets by the program who is going to receive the packet
> - when multiple programs share a socket (i.e. they listen on the same=
 socket),=20
> allow the packet only if all programs are allowed to receive the pack=
et

Besides the tasklist_lock issues, there is no 1:1 relationship between
sockets and processes, which is why this can never work. You don't know
which process is going to receive a packet until it calls recvmsg().

There is some work in progress to solve this problem in a different way=
,
by adding new hooks to the protocols that get the socket as context,
and using SElinux labels instead of process names/inodes/whatever for
matching.
