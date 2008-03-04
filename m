From: "Andrea Bencini" <andrea.bencini@tin.it>
Subject: bridge firewall and iptables.
Date: Tue, 4 Mar 2008 10:51:47 +0100
Message-ID: <001801c87ddd$6183a140$0200640a@wtlc>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpsrv.playnet.it ([62.48.32.171]:32991 "EHLO
	smtpsrv.playnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbYCDKBl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:01:41 -0500
Received: from PlyMail10.playnet.it (unknown [62.48.32.180])
	by smtpsrv.playnet.it (Postfix) with ESMTP id 656CCB6B
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Mar 2008 10:51:13 +0100 (CET)
Received: from wtlc ([150.217.211.26])
        by PlyMail10.playnet.it (Playnet Mail Server v1.0) with ASMTP id KMD51812
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Mar 2008 10:51:12 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have a bridge firewall with dhcp server.

I want that only internal-network clients (eth1-bridge side) can use 
dhcp-server and I want to stop every 
DHCPDISCOVER-DHCPOFFER-DHCPREQUEST-DHCPACK etc.. from/to local-network 
clients (eth0-bridge side).

How can I put in practise some rules in my bridge firewall (iptables) to do 
this?

I installed FC8;
iptables-1.3.8-6.fc8

My global network:10.100.0.0/24

Internal-network address range (eth1-bridge side) :from 10.100.0.65 to 
10.100.0.78 (I think I can write 10.100.0.64/28).

dhcp configuration: range dynamic-bootp 10.100.0.65 10.100.0.78

ifcfg-eth0 configuration:
DEVICE=eth0
BOOTPROTO=static
HWADDR=00:50:8B:67:82:6F
ONBOOT=yes

ifcfg-eth1 configuration:
DEVICE=eth1
BOOTPROTO=static
HWADDR=00:50:8B:67:68:A4
ONBOOT=yes

Bridge configuration:
brctl addbr br0
brctl addif eth0
brctl addif eth1
ifdown br0
ifconfig br0 10.100.0.55 netmask 255.255.255.0
ifup br0

Can you help me?

Thanks
Andrea 

