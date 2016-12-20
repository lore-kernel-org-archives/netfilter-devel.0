From: Llorente Santos Jesus <jesus.llorente.santos@aalto.fi>
Subject: Feature request: Load u32 value into packet mark
Date: Tue, 20 Dec 2016 11:24:13 +0000
Message-ID: <4ea9be0e2a17475485a0b3e6bccc19d3@aalto.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out-02.aalto.fi ([130.233.228.121]:51095 "EHLO
        smtp-out-02.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbcLTLYQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 06:24:16 -0500
Received: from smtp-out-02.aalto.fi (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 5AA5227134A_85914DEB
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 11:24:14 +0000 (GMT)
Received: from exng1.org.aalto.fi (exng1.org.aalto.fi [130.233.223.20])
        by smtp-out-02.aalto.fi (Sophos Email Appliance) with ESMTP id 2B6AF271348_85914DEF
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 11:24:14 +0000 (GMT)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have been playing quite a bit with iptables lately. Ever since the ipset was updated to support hash:ip,mark sets, there has been the potential to apply efficient matching on packet marks.
Does it make any sense to you to develop a new extension that following U32 and MARK syntax would allow us to read a 32bit value  and load it onto the packet mark ?
To make it even more versatile we could support masking when dumping the value in the packet mark.

The aim is to support very efficient packet matching/classification on any 32 bit field/region of any potential higher level protocol.

For example, read 4 bytes starting at offset 28 of the IP packet (first 4 bytes of the UDP payload), apply a mask of 0xF00F and use that result as the packet mark with mask value 0xFFFF
iptables –A FORWARD -p udp --m udp --dport 12345 -j U32MARK --set-mark "28&0xF00F/0xFFFF"


Best,
Jesus
