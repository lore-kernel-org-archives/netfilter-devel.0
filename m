From: "Samuel Jean" <sjean@cookinglinux.org>
Subject: Working on a match extension (ipt_gateway)
Date: Wed, 14 Jul 2004 21:05:55 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <33216.207.236.166.71.1089853555.squirrel@207.236.166.71>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I'm working on an extension used to match packets by next-hop ip.
It is only valid with FORWARD & POST_ROUTING hooks.
It gets the routing decision via (struct rtable*)skb->dst
and it works quite well.

I just finished on Linux 2.6 and I'm about to do it on 2.4.

I've done it after reading that unanswered post :
http://lists.netfilter.org/pipermail/netfilter/2004-July/054199.html

Please, could someone answer my questions :

1) Is that match useless? (Can this be done without such a match)

2) In case it isn't, how do I send the match?

   A tarball with libipt_gateway.c, ipt_gateway.c and ipt_gateway.h ?
   (Any directory structure ?)

I'm sorry for both questions. As you can see, it's my first real work
on netfilter.

There's a start to anything.

Thanks a lot,

--=20
Samuel Jean
SysAdmin & NetAdmin
at cookinglinux.org
