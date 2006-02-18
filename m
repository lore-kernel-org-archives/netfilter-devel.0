From: =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwin@gurde.com>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both incoming and outgoing packets
Date: Sat, 18 Feb 2006 22:03:41 +0200
Message-ID: <200602182203.41823.edwin@gurde.com>
References: <200602181420.02791.edwin@gurde.com> <43F77571.7020100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932127AbWBRUEI@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43F77571.7020100@trash.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Saturday 18 February 2006 21:28, Patrick McHardy wrote:
> T=F6r=F6k Edwin wrote:
> > First of all this is what I'd like to achieve:
> > - filter packets by the program who sent the packet
> > - filter packets by the program who is going to receive the packet
> > - when multiple programs share a socket (i.e. they listen on the sa=
me
> > socket), allow the packet only if all programs are allowed to recei=
ve the
> > packet
>
> Besides the tasklist_lock issues, there is no 1:1 relationship betwee=
n
> sockets and processes, which is why this can never work. You don't kn=
ow
> which process is going to receive a packet until it calls recvmsg().
Can sockets be "labeled". Like creating a label for each process, and t=
hen=20
apply a label to each socket they open. If a socket gets shared, then i=
t gets=20
multiple labels.
I see that you talk about SELinux labels below, but is there a way to "=
label"=20
anything without using SELinux? (Maybe by writing another LSM module th=
at=20
does just this socket labeling?)
I could then just check the labels to see if a packet is allowed to pas=
s/ or=20
not.
>
> There is some work in progress to solve this problem in a different w=
ay,
> by adding new hooks to the protocols that get the socket as context,
> and using SElinux labels instead of process names/inodes/whatever for
> matching.
Could you tell me on which thread/mailing list this discussion/(work in=
=20
progress) is taking place? I'd like to follow it.

Thanks
Edwin
