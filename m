From: Tugrul Erdogan <h.tugrul.erdogan@gmail.com>
Subject: Network namespace and neighboring subsystem problem
Date: Thu, 8 Sep 2016 14:34:14 +0300
Message-ID: <CA+whn7QrRFJSCFBkqojRgiSb2iXQnh+GPp3gjcbjGXzuJuwd9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36077 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757802AbcIHLeQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 07:34:16 -0400
Received: by mail-wm0-f42.google.com with SMTP id b187so163337816wme.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Sep 2016 04:34:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I have a problem on neighboring subsystem on network namespace.  I am
successfully  use bridged interface on the test device without ip
address to connect client and server by positioning the test device
between them.

My test scenario as follows:
After initialization of the test device, the arp cache of the test
device is empty. There is route rules that route packages via device
name. The traffic between client and server flows successfully by
bridged interface of the test device. But I want to be able to ping
client or server from the test device too.

As a successful case of my test scenario: I use ping tool on root
namespace of bridged device (or without namespace configurations). An
arp entry is created on arp table (with <incomplete> state) and arp
requests are transmitted by bridged device until an arp reply comes
back. By the arp reply comes back, the mac address of the ping
destination is written to the <incompleted> stated arp entry of arp
table and  "icmp echo request" begins to transmit.

As the unsuccessful case of my test scenario: I use ping tool on
namespace (not root namespace). The arp cache is empty. But instead of
creating an arp request to get mac address of ping destination, the
"icmp echo request" is sent with broadcast (FF:FF:FF:FF:FF:FF)
destination mac address. My problem is that why a broadcast icmp
package is sent instead of as an unicast icmp package (by determining
destination mac address with an arp request). As a work-around, if I
assign an ip address to bridged interface and then release that ip
address, ping requests become to trigger arp requests and unicast icmp
packages.

When I inspect the reason of this problem I saw that; in
__inet_dev_addr_type function, the fib_get_table function returns NULL
if I route packages at a namespace. Only after the workaround which is
explained above is applied, the fib_get_table function returns
non-NULL value.

I know that it is a special use case which is pinging from bridged
ipless interface, but I really need that case. So I want to take your
opinions about my problem, could it be a bug for regular use cases too
and how can I solve this problem. Thanks for your helps.

Best regards,
Tugrul
