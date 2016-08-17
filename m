From: Tommy Knowlton <tommy.knowlton@gmail.com>
Subject: ulogd plugin development question
Date: Wed, 17 Aug 2016 10:10:00 -0600
Message-ID: <CAFJN8cshXGXyrPJ1shm_AWS4hmRhyV9wucBuV17RnRWq2JmfVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35730 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbcHQQKl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 12:10:41 -0400
Received: by mail-io0-f178.google.com with SMTP id m101so139582006ioi.2
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 09:10:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've got some questions about ulogd internals. I'm not sure this is
the right list, but I can't find another that would seem to be any
closer to the audience that I want to receive my questions.

If anyone knows where a list more directly involved with ulogd
developers is hosted, please point me at that. I'll state my question
here just in case any of those folks are also here.

I develop and maintain my company's internal PaaS, which is based on
open-source Cloud Foundry. I've been working recently to add logging
when network packets from a containerized app get dropped by the
platform, and other similar logging.

I'm accomplishing the logging by adding iptables `-j NFLOG` rule, in
conjunction with a couple of custom ulogd plugins. One plugin (filter)
translates IP addresses to container guids, and another plugin
(output) formats the message and forwards it to the logging component
running on the vm that hosts the user-app containers.

The questions relate to an enhancement to the logging I've described
above. In addition to "packet dropped by container security rules"
logging, we also want to log conntrack events: new connection
established, and destroy event on non-assured connection, i.e., "your
container tried to make an outbound connection, the packets were not
dropped by container security, but something else between here and
there prevented establishment of a connection".

I am trying to generalize the output plugin so that it receives its
message format string from stack configuration in ulogd.conf. For
example,

> stack=diegolog:NFLOG,empty:BASE,empty:IP2STR,empty:DIEGOINSTANCE,droplogger:DROPSONDE
>
> [diegolog]
> group=26
>
> [empty]
>
> [droplogger]
> format="DROP {{ikey \"ip.daddr.str\"}}{{with ikey \"ip.protocol\"}}{{if eq . 6}}:{{ikey \"tcp.dport\"}}{{else if eq . 17}}:{{ikey \"udp.dport\"}}{{end}}{{end}} (seehttp://tiny/faq1)"


(a side note: my ulogd plugins are written mainly in golang, with
minimal C code for linkage - that's why the format string looks like a
golang text/template template)

Up to this point, I've got "packet drop" logging working, with a
_hard-coded_ log message. The above _configurable_ logging would be to
support an enhancement to log "interesting" conntrack events - and we
expect to discover additional definitions of "interesting" over time.
Ideally, adding more container network logging will be a matter of
declaring additional ulogd stacks and adding iptables rules `-j NFLOG`
or `-j NFCT`, and more to the point, _not_ writing additional code in
the ulogd plugins.

The problem is, and my reason for posting to the list, I don't yet see
a good way to deal with the keys at plugin registration time. Ideally,
I'd just register for all okeys produced by either
ulogd_raw2packet_BASE.so or ulogd_inpflow_NFCT.so. The problem is
illustrated by the packet-drop-logger configuration quoted above: not
every stack is going to include a ulogd_inpflow_NFCT.so, and it's a
downstream plugin (my custom DROPSONDE output) that needs to know, at
plugin registration time, what ikeys it needs ulogd to wire up for it.
I've tried registering ikeys for all okeys produced by the BASE and
NFCT, but when ulogd tries to plumb the stack above (which does not
include NFCT because there's no need in that case, it explodes because
no plugin provides e.g. `orig.ip.saddr`.

I'm wondering whether it's {possible, advisable}? to register the
plugin with ulogd with some minimal (maybe even empty) set of ikeys,
and then to "update" the plumbing at the time the pluginstance
`configure` callback is called? Or, maybe someone close enough to
ulogd can see another way for me to declaratively, in ulogd.conf,
state the keys the my output plugin instance requires?

Thanks,
~ Tommy Knowlton
