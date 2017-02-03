From: Shaun Crampton <shaun@cantab.net>
Subject: Concurrent iptables-restore calls clobberring each other
Date: Fri, 3 Feb 2017 20:37:49 +0000
Message-ID: <CAB3ewxODtiHoKQChouTcYX7uZxHvHobxxCMLtOH_Uvkco9XaGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34738 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbdBCUhv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 15:37:51 -0500
Received: by mail-io0-f193.google.com with SMTP id c80so3400904iod.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Feb 2017 12:37:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to diagnose an incompatibility between my application
(Project Calico's Felix daemon) and another (Kuberenetes' kube-proxy).
Both are (ab)using iptables-restore to do high-speed bulk updates to
iptables and they're both using --noflush so they can use
iptables-restore to edit only some chains.  Mostly, this works great
and it's many times faster than using individual iptables commands.
However, sometimes when they do an iptables-restore at the same time,
I see one of the updates get lost even though the command reported
success.  I've boiled it down to a repro script[1] that starts two
threads writing to iptables and looks for missing updates.

My understanding is that each iptables-restore call actually does a
read-modify-write of the whole table so it's not too surprising that
we could get a missed update.  However, I thought that iptables has
some sort of sequence number to prevent clobbering, making it a
compare-and-swap operation.  I've certainly seen iptables-restore
calls fail on the COMMIT line when doing concurrent updates and I have
a tweaked script[2] that exhibits that behaviour.  In script [2] I
added an extra superfluous rule update to one of the writers and
suddenly the COMMIT starts failing as I was hoping.  While the toy
example in [2] seems to work, if I add more operations, it seems to go
back to failing again so it may just be a timing window.

Output from script [1] (it quickly fails after detecting a lost update):

$ sudo ./iptables.sh
[sudo] password for shaun:
akKkKkKkKkiptables-restore: line 4 failed
AbKkKkBKkCaKkAbKkBKkCaKkAbKkBKk
FELIX-B update was clobbered

Output from script [2] (keeps going for as long as I've let it run):

$ sudo ./iptables.sh
akKkAbKkBKkCaKkAbKkBKkKCakAbZkBZkKkCaKkAbKkBCaKkAbBZkKkKkCaKkAbKkBZkKkCaKkAbKkBKkKkCaKkKkAbKkBKkKkCaKkAbKkBZkKkCaKkAbKkBKkCaKkAbKkBZkKkCaKkAbKkBKkKkCaKkAbKkBKkKkCaAbKkKkBKkKkCaKkAbKkBKkCaKkAbBZkCaKkAbKkBKkKkCaKkAbBCa....

Where a K means that the "kube" thread successfully wrote to iptables
and a Z means it got a "COMMIT failed".

It'd be great to know if this is working as designed or a bug, or if
there's a way to make sure that I get a COMMIT failure if there's been
a concurrent update.  Without that, I'm thinking we'll have to do a
regular poll to make sure that nothing got clobberred.

I'd appreciate if you CCed me on any responses since I'm not
subscribed to the list.  Thanks,

-Shaun

[1] https://gist.github.com/fasaxc/ee443a9ef82ce2e4dab059161f095ec2
[2] https://gist.github.com/fasaxc/05a80a48211500e4f2225011a131f92e
