From: "Giacomo" <delleceste@gmail.com>
Subject: help writing kernel module for nat
Date: Thu, 8 Sep 2005 14:50:54 +0200
Message-ID: <001d01c5b473$f5c515e0$0300a8c0@giacomino>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Good morning.
I'm writing a nat module for study purposes in linux kernel.

I do NAT, changing addresses and port in network packets (outgoing and 
coming back)
Then i recalculate checksum.

i don't mangle payload (not interested in ftp).

Should i do any other adjustment? (TCP window, seq/ack) ?

I think it should be enough, since process should be transparent to hosts 
behind nat machine,
the fact is that in some networks it works fine, in other networks 
communication fails.

Tried changing mtu and clamp-tcpmss-to-pmtu with no effect.

Thanks-

Giacomo.
