From: r00t <root@server.titansoft.ru>
Subject: REDIRECT
Date: Mon, 13 Dec 2004 18:36:31 +0500
Message-ID: <1538174627.20041213183631@server.titansoft.ru>
Reply-To: r00t <root@server.titansoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hi all,
>> How to i make by libipq  this rule:
>> -j REDIRECT --to-ports 3128 ?

>You don't.
>REDIRECT or other NAT related operations must be done in the kernel.

Ok, but if i use this:

-A PREROUTING -p tcp -j QUEUE
-A PREROUTING -i eth1 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3128

And in the program:

ipq_set_verdict(h, m->packet_id,NF_ACCEPT, 0, NULL);

the packet not going to second rule(REDIRECT)

Sorry to my english
Best regards, Meg
