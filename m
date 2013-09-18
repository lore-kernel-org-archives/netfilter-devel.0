From: =?ISO-8859-1?Q?S=E9bastien_LAVEZE?= <slaveze@gmail.com>
Subject: Conntrack events using SMP
Date: Wed, 18 Sep 2013 13:49:37 +0200
Message-ID: <CAMLNKhhZ16kjkQvzekZajjvu4FXuUszvj_VQjGub59ivsRwMsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:60070 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3IRLtj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:49:39 -0400
Received: by mail-la0-f42.google.com with SMTP id ep20so5636317lab.29
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2013 04:49:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I have an application (quite close to conntrackd) that mirrors
Conntrack connection table using Conntrack events.
I used to run it on a non-SMP system without any issues and recently
moved to SMP.

So my goal is that my application mirrors exactly the kernel conntrack
connection table.

To stress conntrack events, I have an "opened" firewall (basically no
rules at all) and I forward UDP packets symetrically on two
interfaces.
On top of that I create more connections that nf_conntrack_max so that
it triggers early_drop mechanism and creates a LOT of events
(continuous flow of connection creation and deletion)
I'm using kernel 3.2.26

>From my observations after running this test I have a few questions:

1. Using SMP there is no guarantee of events ordering. For the same
conntrack (5-tuple + id) I have seen that a DESTROY event can race
with an UPDATE for example. Am I right ?
However this is something which is possible to handle correctly in user-space.

2. I decided to use reliable events to avoid costly resync in case of event loss
So far I have a good behavior concerning DESTROY events (Never
observed remaining connections in my application that do not exist in
kernel).  However I noticed that I was missing many NEW or UPDATE
events.
By looking into ecache code I noticed that once the conntrack has
reached its CONFIRMED state and that the event delivery fails, we will
never try to resend the event again when the packet goes through
nf_conntrack_confirm again. (because e->cache has been set to zero...)
This a bit problematic because my user-space application has no way of
knowing that events have been lost using reliable events.
Is this the expected behavior ?

Regards,
Sebastien
