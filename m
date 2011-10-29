From: Rieker Flaik <rieker_flaik@arcor.de>
Subject: add packet filter rule from within kernel module
Date: Sat, 29 Oct 2011 16:23:47 +0200
Message-ID: <1319898227.3314.45.camel@lovely>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:57738 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932565Ab1J2OQI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Oct 2011 10:16:08 -0400
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id 36B2C30311
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2011 16:16:07 +0200 (CEST)
Received: from mail-in-15.arcor-online.net (mail-in-15.arcor-online.net [151.189.21.55])
	by mail-in-10-z2.arcor-online.net (Postfix) with ESMTP id 2BF2A9F
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2011 16:16:07 +0200 (CEST)
Received: from [192.168.1.151] (d90-134-52-81.cust.tele2.de [90.134.52.81])
	(Authenticated sender: rieker_flaik@arcor.de)
	by mail-in-15.arcor-online.net (Postfix) with ESMTPA id 0C5121AB740
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2011 16:16:07 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

 I have "homebrewed" a small usb-device with LEDs, a button and its
kernel-module. It is just for me and my educational purpose.

What I would like to achieve:

 If button is triggered: The "kernel-netfilter-equivalent"
of 'iptables -A INPUT -p tcp -j DROP' should get called from within the
kernel by my module.

So that there would be no need for a detour to userspace by e.g the
input system which feeds an input-daemon which then would call some
iptables control script.

Could you please give me a hint in the right direction which function I
could use, should use or should not use? Some docu, example or similar
module would be certainly great too :)


Thanks,
 Rik

