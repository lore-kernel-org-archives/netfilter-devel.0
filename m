From: Justin Michael Schwartzbeck <justinmschw@gmail.com>
Subject: IPTables connection mark rule stops working
Date: Tue, 15 Dec 2015 11:44:14 -0600
Message-ID: <CAGEc96=TMfuQSuLWimfRbU0hXwHSj2pmGCmhhFs9AjZnYmx=eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:36797 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbbLORoP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Dec 2015 12:44:15 -0500
Received: by mail-vk0-f46.google.com with SMTP id y187so10456455vka.3
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 09:44:14 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I was not sure whether to post this in netfilter or netfilter-devel.
Here is my situation:

I have a kernel module that examines traffic that is forwarded to a
linux VM and, depending on certain information in the packet, will
mark that connection accordingly. I use the following line: "skb->mark
= 0x01" where skb is the socket buffer that is passed to a prerouting
hook in the kernel module.

Next, I have an iptables rule that DNATs the traffic based on the
connection mark. For example, mark 1 goes to port 8080, mark 2 goes to
8443, etc. The iptables rule looks like so:
iptables -A PREROUTING -p tcp -m mark --mark 0x1 -j DNAT
--to-destination (proxy ip):8080

Now, 99 percent of the time this works just fine, the connection is
marked, and it gets redirected by the iptables rule, and everyone is
happy. But once in a blue moon, it will randomly just stop working.
Here is what I have gathered so far: I have traffic being forwarded to
my VM as usual. Now I know the traffic is being marked in the kernel
module because I have a log message that goes to syslog from the
kernel module indicating this. But the traffic does not get DNATed.
When I look at "iptables -t nat -vL" I can see that the count for that
rule is not going up. Eventually I just power cycle the VM and
everything goes back to normal. I am wondering how I can troubleshoot
this. What might cause this problem to occur? My first instinct is
maybe some table is being filled up (perhaps connection tracking?) but
when I check syslog I don't see any useful information. I just need
some idea of where to look. What other things can I check?

Thanks,
-Justin
