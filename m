From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: ipt_LOG: MAC address output
Date: Mon, 3 May 2010 15:58:09 +0200
Message-ID: <201005031558.09409.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:39990 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033Ab0ECOQx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 May 2010 10:16:53 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rs02.intra2net.com (Postfix) with ESMTP id 9104F963C
	for <netfilter-devel@vger.kernel.org>; Mon,  3 May 2010 15:58:11 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 0C5112AC53
	for <netfilter-devel@vger.kernel.org>; Mon,  3 May 2010 15:58:11 +0200 (CEST)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id D6C452AC51
	for <netfilter-devel@vger.kernel.org>; Mon,  3 May 2010 15:58:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

below is an ipt_LOG output from kernel 2.6.33.2:

May  3 15:14:40 intratest kernel: REJECT IN=eth0 OUT=
MAC=02:00:00:00:00:29:00:0c:76:28:3e:6c:08:00 SRC=172.16.1.1 DST=172.16.1.145 ...

The MAC address really looks strange if you take
the original data into consideration:

Source: 172.16.1.1 (00:0C:76:28:3E:6C)
Destination: 172.16.1.145 (02:00:00:00:00:29)

The corresponding code in net/ipv4/netfilter/ipt_LOG.c:

ipt_log_packet():
        if (in && !out) {
                /* MAC logging for input chain only. */
                printk("MAC=");
                if (skb->dev && skb->dev->hard_header_len
                    && skb->mac_header != skb->network_header) {
                        int i;
                        const unsigned char *p = skb_mac_header(skb);
                        for (i = 0; i < skb->dev->hard_header_len; i++,p++)
                                printk("%02x%c", *p,
                                       i==skb->dev->hard_header_len - 1
                                       ? ' ':':');
                } else
                        printk(" ");


The current code does the following:
- Output the two MAC addresses separated by ":"
  instead of something readable like " "

- Output the destination MAC address first which
  is a bit unexpected as the first shown IP is
  the IP address of "SRC".
 
  Idea: Maybe print "MACSRC= " and "MACDST= ". Leave out
  the "MACxxx= " output if the MAC address is not known.

- Output "08:00" garbage at the end.

Could it be that "skb->dev->hard_header_len" is longer
than the MAC address header field?

Cheers,
Thomas
