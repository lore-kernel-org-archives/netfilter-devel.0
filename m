From: Juergen Schmidt <abcdmail@freenet.de>
Subject: iptables: incorrect package match w/ conntrack_sip
Date: Mon, 14 Nov 2016 17:11:51 +0100
Message-ID: <e1d64313-f391-8609-8ef2-188a82c404d5@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:57598 "EHLO mout1.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932260AbcKNQPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 11:15:43 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
        by mout1.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.85 #1)
        id 1c6Jux-0002rK-Id
        for netfilter-devel@vger.kernel.org; Mon, 14 Nov 2016 17:15:35 +0100
Received: from localhost ([::1]:54468 helo=mjail0.freenet.de)
        by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.85 #1)
        id 1c6Jux-0006Gk-Bm
        for netfilter-devel@vger.kernel.org; Mon, 14 Nov 2016 17:15:35 +0100
Received: from mx7.freenet.de ([195.4.92.17]:46964)
        by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.85 #1)
        id 1c6Js3-0003Ul-DD
        for netfilter-devel@vger.kernel.org; Mon, 14 Nov 2016 17:12:35 +0100
Received: from p5deb07f1.dip0.t-ipconnect.de ([93.235.7.241]:34104 helo=mail.maya.org)
        by mx7.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256) (port 587) (Exim 4.85 #1)
        id 1c6Js3-0006Rj-9v
        for netfilter-devel@vger.kernel.org; Mon, 14 Nov 2016 17:12:35 +0100
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
        by mail.maya.org (8.14.7/8.13.8) with ESMTP id uAEGCWJS003575
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 17:12:32 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!


I registered sip helper like this w/ kernel 4.8.7:

iptables -I OUTPUT -t raw -p udp -o ppp0 -s $MyInternetIP
--dport 5060 --sport 5060 -j CT --helper sip

or

iptables -I PREROUTING -t raw -p udp -i ppp0 -d $MyInternetIP
--dport 5060 --sport 5060 -j CT --helper sip


Now, the rtp packets should be matched by (according [1])

iptables -I OUTPUT -p udp -o ppp0 -s $MyInternetIP -d 217.0.0.0/13 -m
conntrack --ctstate RELATED,ESTABLISHED -m helper --helper sip -j ACCEPT

or appropriate rule for incoming packages.


This is true in *most* cases, but unfortunately *not always*. There are
some situations where the following rule w/o sip helper condition
unexpectedly matches and *not* the above one:

iptables -I OUTPUT -p udp -o ppp0 -s $MyInternetIP -d 217.0.0.0/13
-m conntrack --ctstate RELATED -j ACCEPT

Further more:
This rule (e.g.)

iptables -I INPUT 1 -p udp -i ppp0 -d $MyInternetIp -m conntrack
--ctstate RELATED,ESTABLISHED -j ACCEPT

matches *all* packages including the packages which are matched by the
--helper sip - rule.


Why does iptables behave like this? From my point of view and according
documentation, the rule w/o sip helper condition should never match (for
security reasons).

How can I debug this behavior? Or is this the intended behavior and I
missed something? I would be glad if somebody could clarify this behavior.



Thanks,
Juergen.


[1] https://home.regit.org/netfilter-en/secure-use-of-helpers/
