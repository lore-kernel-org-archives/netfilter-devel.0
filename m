From: "justin joseph" <justinjoseph007@gmail.com>
Subject: bug in iptables
Date: Fri, 15 Feb 2008 00:08:10 +0530
Message-ID: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:17105 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763356AbYBNSiT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:38:19 -0500
Received: by el-out-1112.google.com with SMTP id v27so465841ele.23
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Feb 2008 10:38:18 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I were testing shorewall with some configuration and found a bug in
shorewall version 3.4.4.

It seems to be there in iptables as well.

23:51 < justin007> I were testing shorewall and got a bug which seems
to be there in netfilter as well.
23:51 < justin007> iptables -t mangle -A tcpost -i lan1 -s
192.168.10.10 -o wan1 -p tcp --dport 22 -j CLASSIFY --set-class 1:11
23:52 < justin007> in tcpost the -i interface name is invalid,
iptables takes it though.
23:53 < jengelh> interesting
23:53 < jengelh> actually
23:53 < jengelh> ...
23:55 < jengelh> and, is it bad? no.
23:55 < jengelh> it does not crash the machine so all is fine for now
23:57 < justin007> yes it does not crach the machine. But it matches
all ports, *. which is not expected behaviour. man page does say that
the -i interfacenmae option is valid only in pre,
                   foreward, input chains
23:57 < justin007> Just wanted to mention this.
23:59 < jengelh> right
23:59 < jengelh> post it to the mailing list  (or I will do) so noone
forgets about it
Day changed to 15 Feb 2008
00:00 < justin007> please do post, I would need to join the list in
the first place :-)
00:01 < jengelh> you don't need to subscribe
00:01 < jengelh> just post to netfilter-devel@vger
00:01 < justin007> ok, I will post.
00:02 < jengelh> "Use of interface specification (e.g. -i) is not
checked against hooks when custom chain is used"
00:02 < jengelh> iptables -N foo; iptables -A foo -i eth0; iptables -A
OUTPUT -j foo;
00:03 < jengelh> That's all :)
00:03 < jengelh> short, sweet and to the point
00:05 < justin007> where is that from, I don't see it with man iptables
00:05 < jengelh> oh I just wrote that
00:05 < jengelh> that's what I would have written into the mail
00:05 < justin007> :-)

-justin
