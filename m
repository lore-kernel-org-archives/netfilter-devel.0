From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 05/13] Handle TCP SYN+ACK/ACK/RST transparency
Date: Mon, 1 Oct 2007 00:02:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710010001460.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <Pine.LNX.4.64.0709302344450.7130@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709302345440.7130@fbirervta.pbzchgretzou.qr> <200709302359.38311@nessa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53471 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbXI3WC1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:02:27 -0400
In-Reply-To: <200709302359.38311@nessa>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 30 2007 23:59, KOVACS Krisztian wrote:
>> ---
>>  net/ipv6/tcp_ipv6.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6.22.3/net/ipv6/tcp_ipv6.c
>> ===================================================================
>> --- linux-2.6.22.3.orig/net/ipv6/tcp_ipv6.c
>> +++ linux-2.6.22.3/net/ipv6/tcp_ipv6.c
>> @@ -73,7 +73,7 @@
>>  static struct socket *tcp6_socket;
>>
>>  static void	tcp_v6_send_reset(struct sock *sk, struct sk_buff *skb);
>> -static void	tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct
>> request_sock *req); +static void	tcp_v6_reqsk_send_ack(struct sk_buff
>> *skb, struct request_sock *req, int); static
>> void	tcp_v6_send_check(struct sock *sk, int len,
>>  				  struct sk_buff *skb);
>
>This is already _in_ the patch I've sent.

Hm, my bad, did not look to far. (Also these were the 2.6.22 ones -
I should probably update)
