From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: netfilter efficiency
Date: Fri, 21 Jan 2005 08:39:35 -0500 (EST)
Message-ID: <7958.142.169.215.10.1106314775.squirrel@142.169.215.10>
References: <005c01c4ff19$508ade80$c0de623e@MAURO>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <005c01c4ff19$508ade80$c0de623e@MAURO>
To: "MauroTablo'" <m.tablo@libero.it>
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

On Thu, January 20, 2005 12:56 pm, MauroTablo' said:
> Hi all.

Hi !

> [...]
> The question is: iptables confronts the TCP packet with all my 90 rules=
,
> or it confronts the packet ONLY WITH rules for tcp packets (-p tcp)?
> In other words, is there a function in netfilter that looks up to the
> protocol type of a transit packet and decides which rules to confront t=
he
> packet with?

Unfortunately, not as far as I know. The NFC_CACHE system hasn't been
implemented yet.

There were plans for this, but I think it won't be implemented untill
pkttables is out. (Just a guess)

By now, your packets just hit every rules and test against your -p proto.

>
> Thank you.
> Mauro.
>

Cheers,

Samuel
