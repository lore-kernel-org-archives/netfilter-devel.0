From: Matteo Croce <technoboy85@gmail.com>
Subject: Re: nftables null pointer
Date: Tue, 5 Aug 2014 17:07:28 +0200
Message-ID: <CAFnufp0Mjc6yXywRVRiU=kYZw=USSQr=VFfG1gyiPXB53ZMMiQ@mail.gmail.com>
References: <CAFnufp1157iUqOpax6Po-PZivC_7TQSeQqtmJnnpNLVm3hzH9w@mail.gmail.com>
 <20140805100141.GA3480@salvia> <CAFnufp3mVBFVfLOmb3QofpPDubCYgzmOUc4u4vGM6gXv+6Rezg@mail.gmail.com>
 <20140805133907.GA3782@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:48583 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaHEPIJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:08:09 -0400
Received: by mail-qa0-f43.google.com with SMTP id w8so1053061qac.16
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Aug 2014 08:08:08 -0700 (PDT)
In-Reply-To: <20140805133907.GA3782@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2014-08-05 15:39 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Could you give a try to the following patch? Thanks.

yes it works, but the rules are appended every time, not overwritten,
is it the intended behaviour?
I have this after a few run:

table ip nat {
        chain post {
                 type nat hook postrouting priority 0;
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
        }

        chain pre {
                 type nat hook prerouting priority 0;
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 tcp dport { 51413, 4665, 4672} dnat 192.168.0.20
                 iif eth0 udp dport { 51413, 4665, 4672} dnat 192.168.0.20
        }
}

-- 
Matteo Croce
OpenWrt Developer
