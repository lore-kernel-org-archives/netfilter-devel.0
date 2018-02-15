From: Fran Fitzpatrick <francis.x.fitzpatrick@gmail.com>
Subject: Userspace nft parser limitations / suggestions / help
Date: Thu, 15 Feb 2018 09:45:06 -0600
Message-ID: <CALOK-OeL4YPdfpH_QHkmJbx0hjuKhbDYp7+7Mm=PGmsXJ2d7kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33862 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424474AbeBOPp2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 10:45:28 -0500
Received: by mail-qk0-f175.google.com with SMTP id o7so74765qkc.1
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 07:45:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning,

I've recently switched to using nftables for one of our customer
environments that we manage, and there were a few limitations that I
have seem to run into, so I'd like to bring them up here for
discussion (since I could just be missing something and it may be
available and I just don't know it).

Also, in my particular use case, we're managing large sets of
whitelists/blacklists, so keeping that in mind might help...

1) Matching selectors in one rule with an OR

In one scenario, I have a large set of whitelisted IP addresses. To
accept these, I have to write two rules:

ip saddr @whitelist accept
ip daddr @whitelist accept

Ideally, I would like to efficiently write these as one rule, so I
intuitively tried this:

ip {saddr, daddr} @whitelist accept

I additionally had a scenario where I needed to match against TCP or
UDP ports, so I tried something like:

{tcp, udp} {dport, sport} 51 accept

But, that didn't work.  I think there should probably be some way to
match in an or-like fashion, and this might be a nice intuitive syntax
we might be able to use.

Thoughts?

2) Using elements from a set in a rule

In this scenario, I have a large set of IPs and Ports I need to
accept.  So, my set and elements looked something like:

add set traffic exceptions { type ipv4_addr . inet_service . inet_protocol ; }
add element traffic exceptions { 1.2.3.4 . 80 . tcp }
add element traffic exceptions { 1.2.3.4 . 443 . tcp }
add element traffic exceptions { 1.2.3.4 . 53 . udp }
add element traffic exceptions { 1.2.3.4 . 123 . udp }

However, when writing the rule, there was no way for me to to use the
inet_protocol listed in the set to select the protocol type. My
example rule might be:

add rule traffic forward ip daddr . tcp dport . inet_protocol @whitelist accept

I'm not sure this syntax is ideal, but I think it shows what I'm
trying to do, which is _use_ the information in the set to match
against a TCP or UDP port, depending on the element.

I think doing it this way is more ideal than doing an OR for TCP/UDP
(as discussed in #1; {tcp, udp}) because I'm specifically accepting
the packet I want to accept.

3) Complex Real-World Use Cases

Alright, well, here's where it gets complicated.  My gut is telling me
I just need to figure out a way to represent my rulesets properly with
the data I have, so please let me know...

As discussed earlier, I'm mainly dealing with a large list of
"exceptions", or items in a whitelist.  Here are some example of an
exception:
TCP: 0.0.0.0/0:0-65635 --> 192.168.1.100:80, 443 : accept (let anyone
talk to TCP 80, 443)
UDP: 0.0.0.0/0:0-65635 --> 192.168.1.101:53 : accept (let anyone talk
to UDP DNS)
UDP: 0.0.0.0/0:0-65635 --> 192.168.1.102:123 : accept (let anyone talk
to UDP NTP)
TCP: 192.168.1.100:1024-65635 --> 157.240.18.35:443 : accept (let this
one machine talk to Facebook)

Now I can't figure out how to represent those "rules" efficiently in
nft.  Since I'm dealing with a list of a few thousand exceptions, I
thought I would need a set.  But it doesn't look like I'm able to
because I need a range of ports to allow.

What am I missing here?

Thanks,
Fran
