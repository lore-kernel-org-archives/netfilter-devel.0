From: Padmalochan Moharana <padman.m@gmail.com>
Subject: Regarding write send a packet to network that received in
	NF_IP_PRE_ROUTING
Date: Tue, 20 Jul 2010 16:19:06 +0530
Message-ID: <AANLkTilFBhfh-jBBaO4eJAzDw0gU_PhBEcEc1mdsUjjo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38383 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0GTKtH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:49:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

i am facing problem during sending a packet that received in
NF_IP_PRE_ROUTNG hook to network again  .
After receive a packet i have update the source and destination IP.
then i have recalculate the checksum for IP and UDP layer. then i have
to send that packet to network by using below command.

	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, skb->dev, dst_output);
	ret = NF_STOLEN;
	return ret;

But after loading my module kernel hang when it receive any data from peer.

is there any other way to forward a packet to network after
modification of IP header/

Regards,
Padmalochan
