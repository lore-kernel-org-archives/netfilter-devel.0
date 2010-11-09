From: Tommaso Calosi <tcalosi@gmail.com>
Subject: balance traffic between virtual interfaces on the same network
Date: Tue, 9 Nov 2010 14:36:25 +0100
Message-ID: <AANLkTi=bi5TkpZaN=af1YZZDDLt3P9H3k1s7mNk7xQAJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32836 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0KINg2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:36:28 -0500
Received: by wyb36 with SMTP id 36so4815851wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Nov 2010 05:36:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

This is my setup:

eth0:1 192.168.1.10/24
eth0:2 192.168.1.20/24
eth0:3 192.168.1.30/24

gateway 192.168.1.1

I know it's a strange question but it's crucial to do this in my setup.
I need to balance traffic between these virtual interfaces so that the
gateway sees the traffic originating from 1.10, 1.20,  and 1.30. Is it
possible
