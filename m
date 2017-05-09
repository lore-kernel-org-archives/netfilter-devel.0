From: Sergey Yermakov <sergey@epmaki.net>
Subject: Re: Changing destination ip and port of TEE'ed udp
Date: Mon, 8 May 2017 18:51:51 -0600
Message-ID: <bf8bd631-544f-4935-af98-5506a67f1da4@epmaki.net>
References: <fbc2b521-5f4d-dc10-ee52-c17c5fbc810c@epmaki.net>
 <6411b93c-1e13-19ea-b90a-d41df584502e@epmaki.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:52427 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbdEIAvy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 20:51:54 -0400
Received: from [192.168.0.31] ([75.171.210.125]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Lw03n-1e6Lmn2ixJ-017lNV
 for <netfilter-devel@vger.kernel.org>; Tue, 09 May 2017 02:51:52 +0200
In-Reply-To: <6411b93c-1e13-19ea-b90a-d41df584502e@epmaki.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 > It's not TEE's job to modify the packet - that's for DNAT left to do.

I see. thx.

What would be the best approach using DNAT for the following scenario 
instead of having this ? :

# iptables .. -j TEE --gateway 192.168.0.1 --new-dst 192.168.0.21 
--new-dport 201
# iptables .. -j TEE --gateway 192.168.1.2 --new-dst 192.168.1.22 
--new-dport 201
# iptables .. -j TEE --gateway 192.168.1.2 --new-dst 192.168.1.23 
--new-dport 202

scenario:
I have a server (192.168.3.20/24) that is getting a quite substantial 
amount of udp data on some port and I need to replicate that data out to 
192.168.0.21/24, 192.168.1.22/24 and 192.168.1.23/24 servers ?

thx,
-sergey
