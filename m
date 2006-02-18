From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both
 incoming and outgoing packets
Date: Sat, 18 Feb 2006 21:07:47 +0100
Message-ID: <43F77E93.9080305@trash.net>
References: <200602181420.02791.edwin@gurde.com> <43F77571.7020100@trash.net>
	<200602182203.41823.edwin@gurde.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwin@gurde.com>
In-Reply-To: <200602182203.41823.edwin@gurde.com>
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

T=F6r=F6k Edwin wrote:
> On Saturday 18 February 2006 21:28, Patrick McHardy wrote:
>=20
>>Besides the tasklist_lock issues, there is no 1:1 relationship between
>>sockets and processes, which is why this can never work. You don't know
>>which process is going to receive a packet until it calls recvmsg().
>=20
> Can sockets be "labeled". Like creating a label for each process, and t=
hen=20
> apply a label to each socket they open. If a socket gets shared, then i=
t gets=20
> multiple labels.
> I see that you talk about SELinux labels below, but is there a way to "=
label"=20
> anything without using SELinux? (Maybe by writing another LSM module th=
at=20
> does just this socket labeling?)
> I could then just check the labels to see if a packet is allowed to pas=
s/ or=20
> not.

I'm not familiar with SElinux, so I don't know.

>>There is some work in progress to solve this problem in a different way=
,
>>by adding new hooks to the protocols that get the socket as context,
>>and using SElinux labels instead of process names/inodes/whatever for
>>matching.
>=20
> Could you tell me on which thread/mailing list this discussion/(work in=
=20
> progress) is taking place? I'd like to follow it.

There has been some discussion on netdev and netfilter-devel. I'm
currently porting the patches to a current tree and fixing the
remaining problems, I'll probably post them to netdev in a week or
two.
