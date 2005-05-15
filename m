From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Handling large amounts of data
Date: Sun, 15 May 2005 18:15:13 -0400
Message-ID: <876ef97a05051515154bdb4157@mail.gmail.com>
References: <5ad977d10505151446348e932f@mail.gmail.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Silimite <silimite@gmail.com>
In-Reply-To: <5ad977d10505151446348e932f@mail.gmail.com>
Content-Disposition: inline
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

On 5/15/05, Silimite <silimite@gmail.com> wrote:=20
> My question is, what is the best way to communicate all these ranges
> from user-space into the kernel module?   I am currently loading them
> via procfs.  Is this an acceptable method or should I be looking at
> something else?  It certainly works great but I would like it to be as
> "proper" as possible.

A unicast netlink socket would almost certainly be the best way to go
here. For examples on how to use unicast netlink sockets, look at
net/ipv4/netfilter/ip_queue.c or net/core/rtnetlink.c.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
