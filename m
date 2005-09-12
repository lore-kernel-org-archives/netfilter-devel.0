From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: help understanding a source comment (ip_conntrack)
Date: Mon, 12 Sep 2005 15:50:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0509121345370.18433@blackhole.kfki.hu>
References: <00a001c5b78e$d1143a50$0300a8c0@giacomino>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
In-Reply-To: <00a001c5b78e$d1143a50$0300a8c0@giacomino>
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

Hi,

On Mon, 12 Sep 2005, Giacomo wrote:

> Good morning, i did not understand what problems are concerned with
>
> "The checked segment is in window, but our windows are *not*
> equivalent with the ones of the sender/receiver"

The TCP connection tracking does not (and cannot) keep track the real
states and parameters of the sender or the receiver absolutely.  For
example our windows (in both directions) may be larger than that of the
sender and receiver. The comment is an explicit note to the person who
wants to play with the code in order not to forget about the limitations.
Think about a packet we detect and take into acount which then get lost
in transit to the receiver.

> I have a problem programming a nat module for linux kernel and i would like
> to understand
> the problem pointed out in this comment to see if it could be the cause of
> malfunction.
>
> When translating addresses and ports, is it necessary to deal with windows
> or other parameters
> such as seq/ack numbers? (I don't touch payload, just ips and ports).

You don't need to care about seq/ack if you don't touch the payload.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
