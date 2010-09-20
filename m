From: =?ISO-8859-1?Q?Andr=E9_Graf?= <andre@dergraf.org>
Subject: PacketScript: packet mangling using the Lua scripting language
Date: Mon, 20 Sep 2010 22:04:31 +0200
Message-ID: <AANLkTi=mPHY0JqEm+dDH-QwiFvVLq7r_86+_xp8d7TLM@mail.gmail.com>
Reply-To: andre@dergraf.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37058 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0ITULi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:11:38 -0400
Received: by wwe15 with SMTP id 15so1432wwe.1
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Sep 2010 13:11:21 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

As a part of my master thesis I developed PacketScript - a Netfilter
extension, which enables to extend Netfilter with Lua scripts. The Lua
scripts are loaded with iptables and provide an easy way to deal with
network packets. Here a short example:

# iptables -A INPUT -p tcp -j LUA --script /path/to/my/script.lua

and the /path/to/my/script.lua can contain a Lua function similar to
the following: (Lua uses -- for comments)

-- called by the Netfilter callback function, gets a 'raw' packet
function process_packet(raw)
    -- apply the Ethernet dissector
    ethernet = raw:data(packet_ethernet)

    -- apply the IP dissector
    ip = ethernet:data(packet_ip)

    -- dissect IP source address
    src = ip:saddr()
    if src:get() == "192.168.1.1" then
        -- rewrite IP source address
        src:set("10.0.0.123")
        -- accept packet
        return NF_ACCEPT
    end
    -- drop packet
    return NF_DROP
end

PacketScript was not build with a specific network protocol or
protocol layer in mind, so it offers a simple framework to extend it
with other protocols. The current version provides rudimentary support
for Ethernet, IP, ICMP, UDP, TCP, TFTP, and HTTP. For my thesis I also
developed the possibility to access the Linux workqueue interface
using Lua.

At the moment I am cleaning up the code and write the user
documentation. But, before I put too much extra effort into it I would
really like to know your opinion. Thank you!
