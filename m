From: Roc Bai <buroc83@gmail.com>
Subject: How to redirect the package from eth0 to eth2
Date: Mon, 10 Jan 2011 18:08:10 +0800
Message-ID: <AANLkTik5YfQ4eNzbSVt5QfmaEQnBA=VJ1NbueKgq9nZj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: buroc <buroc@126.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41075 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1AJKIN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:08:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear all:
    in my service, there are four net card.  eth0, eth1, eth2, eth3. I
want to forward the data in from eth0 to eth1, eth2, eth3 with
different application protocol. Does some body send me some ideas on
it?

   1) where i should set the hook: pre-routing or forward?
   2) how to make the route select the target port which i hope?
   3) where i can get some simple source code to learn?

Best Regards

Bai Shuwei
-- 
------------------------

Thinking before action, but you are wasting time if you don't do action.
