From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack manipulation
Date: Fri, 9 May 2003 14:36:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305091431580.9035-100000@blackhole.kfki.hu>
References: <200305082347.41709.lists@ohlmeier.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nils Ohlmeier <lists@ohlmeier.de>
In-Reply-To: <200305082347.41709.lists@ohlmeier.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 8 May 2003, Nils Ohlmeier wrote:

> short question: is it possible to manipulate the entrys of the connection
> tracking (specialy adding and removing entrys) from user space?

Short answer: no.

> phone1 ------ NAT ------- Internet ----- phone2
>
> Phone1 starts a call to phone2 (INVITE message). Phone2 confirms the call (200
> OK message) after the user picked up and starts to send RTP packets to the
> public NAT address immediately. Now the comfirmation message hits the SIP

How can the user (phone1) send RTP packets before receiving the 200 OK
message from phone2?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
