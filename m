From: Oleg <lego12239@yandex.ru>
Subject: nfqueue accepted packet is disappeared
Date: Thu, 8 Jun 2017 21:15:19 +0300
Message-ID: <20170608181519.GA27147@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward10h.cmail.yandex.net ([87.250.230.221]:36305 "EHLO
        forward10h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751383AbdFHSV0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Jun 2017 14:21:26 -0400
Received: from smtp4j.mail.yandex.net (smtp4j.mail.yandex.net [5.45.198.129])
        by forward10h.cmail.yandex.net (Yandex) with ESMTP id 4AC4121955
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Jun 2017 21:14:06 +0300 (MSK)
Received: from smtp4j.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp4j.mail.yandex.net (Yandex) with ESMTP id 2955D324069E
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Jun 2017 21:14:05 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi all!

I have the test environment consists of 2 qemu VMs with next
network configuration:

VM2 eth0 --> [host br1] --> eth1 VM1 eth0 --> [host br0] --> Internet

I test nfqueue based filter running at VM1, which now simply accepts
all packets from eth1 immediately on callback entering:

static int
cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg, struct nfq_data *nfad,
  void *data)
{
	struct nfqnl_msg_packet_hdr *ph;
	unsigned int verdict = NF_ACCEPT;
	int ret;
	
	ph = nfq_get_msg_packet_hdr(nfad);
	ret = nfq_set_verdict(qh, ntohl(ph->packet_id), verdict, 0, NULL);
	if (ret < 0)
		ERR_OUT("nfq_set_verdict() error");
	
	return ret;
}

ping from VM2 works well, but next command is delayed for several seconds:

~# telnet google.com 80

tcpdump on br0 and br1 shows that telnet sends 2 dns requests (A & AAAA)
and we see it on br1:

20:58:20.289941 IP 192.168.78.2.58758 > 8.8.8.8.53: 32688+ A? google.com. (28)
20:58:20.289985 IP 192.168.78.2.58758 > 8.8.8.8.53: 37919+ AAAA? google.com. (28)
20:58:20.315317 IP 8.8.8.8.53 > 192.168.78.2.58758: 32688 6/0/0 A 173.194.222.102, A 173.194.222.100, A 173.194.222.101, A 173.194.222.138, A 173.194.222.113, A 173.194.222.139 (124)

but reply is only 1, because on br0 the second request is disappear:

20:58:20.290354 IP 192.168.77.32.58758 > 8.8.8.8.53: 32688+ A? google.com. (28)
20:58:20.314921 IP 8.8.8.8.53 > 192.168.77.32.58758: 32688 6/0/0 A 173.194.222.102, A 173.194.222.100, A 173.194.222.101, A 173.194.222.138, A 173.194.222.113, A 173.194.222.139 (124)

After 5 seconds telnet repeats 2 dns requests again and now it gets 2
replies. On br1:

20:58:25.294296 IP 192.168.78.2.58758 > 8.8.8.8.53: 32688+ A? google.com. (28)
20:58:25.299535 IP 8.8.8.8.53 > 192.168.78.2.58758: 32688 6/0/0 A 173.194.222.102, A 173.194.222.100, A 173.194.222.101, A 173.194.222.138, A 173.194.222.113, A 173.194.222.139 (124)
20:58:25.300172 IP 192.168.78.2.58758 > 8.8.8.8.53: 37919+ AAAA? google.com. (28)
20:58:25.322761 IP 8.8.8.8.53 > 192.168.78.2.58758: 37919 1/0/0 AAAA 2a00:1450:4010:c0b::8a (56)

On br0 we now see 2 requests as expected:

20:58:25.295072 IP 192.168.77.32.58758 > 8.8.8.8.53: 32688+ A? google.com. (28)
20:58:25.299056 IP 8.8.8.8.53 > 192.168.77.32.58758: 32688 6/0/0 A 173.194.222.102, A 173.194.222.100, A 173.194.222.101, A 173.194.222.138, A 173.194.222.113, A 173.194.222.139 (124)
20:58:25.301021 IP 192.168.77.32.58758 > 8.8.8.8.53: 37919+ AAAA? google.com. (28)
20:58:25.322186 IP 8.8.8.8.53 > 192.168.77.32.58758: 37919 1/0/0 AAAA 2a00:1450:4010:c0b::8a (56)

When i remove from iptables in VM1 nfqueue rule, telnet works well and
all packets are forwared.

So, my question is, what is happen with first AAAA request and how
i can fix this?

kernel: 4.4.6
iptables: 1.4.21
libnetfilter_queue: 1.0.2

Thanks!


-- 
Олег Неманов (Oleg Nemanov)
