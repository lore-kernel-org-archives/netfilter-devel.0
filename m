From: "Jianqing Zhang" <arrow.jianqing@gmail.com>
Subject: Can iptables/netfilter capture an incoming IP packet which is not addressed to the local machine?
Date: Mon, 3 Nov 2008 23:07:28 -0600
Message-ID: <8a38e1330811032107j5edfb76s19073e3618622537@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Can I use netfilter or iptables to capture a packet which is wrapped
by a Ethernet frame with multicast mac address, but the destination IP
address (a unicast address) is not the local one? According to my
experiments, a local application can get such Ethernet frames by a raw
socket, but the payload, the IP packet with unmatched IP dest., cannot
be delivered to upper layers. Can iptables capture it and put it in
QUEUE?

Thanks
