From: Arun Shrimali <arun.reso@gmail.com>
Subject: IPTABLES for pop3 and SMTP
Date: Mon, 23 Mar 2009 20:24:29 +0530
Message-ID: <d1e572e40903230754i6c1cc0c4k811417275cfb9b7f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:38298 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZCWOye (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:54:34 -0400
Received: by qyk16 with SMTP id 16so2523886qyk.33
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2009 07:54:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

Can anybody help me how to configure iptable for pop3 and smtp

I have setup a gateway server FC9, the network details are as follows :

LAN (172.16.251.0/255.255.255.0 ) ---> Linux server (fedora 9, eth1
172.16.251.234, eth2 172.16.250.246, gw 172.16.250.245) <--router
(172.16.250.245)---> internet

On gateway server (FC9), I am using squid 3 Stable 13 for HTTP
proxying using NCSA authentication.

Now my LAN clients (all are having static IPs) want to access mails
through outlook express.

Please, advice me, how to set iptables chains on linux machine. I
don't want to use MASQUERAD other wise user would be able to access
Internet directly and squid would be of no use.

Can anyone provide me a simple solution.

Thank you very much and regards.

Arun
