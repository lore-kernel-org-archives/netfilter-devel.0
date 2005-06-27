From: thomasmkling@arcor.de
Subject: buckets-byte per conntrack
Date: Mon, 27 Jun 2005 16:27:55 +0200 (CEST)
Message-ID: <29003954.1119882475361.JavaMail.ngmail@webmail-07.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

ip_conntrack version 2.1 (214 buckets, 1712 max) - 208 bytes per conntrack

I searched the archive and didn't find a detailed explanation for these val=
ues, can someone please help me?

208 bytes per conntrack:
i guess that means that 208 bytes are used for managing ip, ports,state, co=
nnection-lifetime, tcp-option,seq-numbers,... (can I see how many bytes for=
 which values used?)

when are the 208 bytes consumed? I started 100 tcp-server-sockets and lost =
100*330 bytes free_memory (vmstat). Then I build a new kernel without conne=
ction tracking and i got exactly the same memory-usage. why, I expected low=
er memory-usage without ip_conntrack?




1712 max:
means that I can only track 1712 connections? what happens if i have more, =
are they denied, invalid, not logged?
if i match on ESTABLISHED and have more than 1712 connections, what then?
how can i have more max?



214 buckets:
nothing found, what's that?




Machen Sie aus 14 Cent spielend bis zu 100 Euro!
Die neue Gaming-Area von Arcor - =FCber 50 Onlinespiele im Angebot.
http://www.arcor.de/rd/emf-gaming-1
