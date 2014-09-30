From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH lnfct] qa: build unshared nfct environment
Date: Tue, 30 Sep 2014 12:16:56 +0200
Message-ID: <20140930101656.GE11709@breakpoint.cc>
References: <20140930090222.GA8470@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34033 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbaI3KQ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:16:57 -0400
Content-Disposition: inline
In-Reply-To: <20140930090222.GA8470@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> nssocket forks and change netns pre-establishd by ip(8), serves its
> socket descriptor to parent via nssocket().  Since this socket is
> isolated, it can be used to create regression tests for conntrack.
> 
> This also adds a conntrack event testcase as a first user.
> A ct_echo_event.sh script is provided to build and run this test
> automatically:
> 
>   # ./qa/ct_echo_event.sh
>   make: Entering directory...
>   ...debug output like:
>       [NEW] tcp      6 2 SYN_SENT src=10.255.255.249 dst=10.255.255.250 sport...
>    [UPDATE] tcp      6 2 SYN_RECV src=10.255.255.249 dst=10.255.255.250 sport...
>   ...
>   [DESTROY] icmp     1 src=10.255.255.249 dst=10.255.255.250 type=8 code=0...
>   # echo $?
>   0

make: Entering directory `git/netfilter.org/libnetfilter_conntrack/qa'
  CC       ct_echo_event.o
ct_echo_event.c:231:12: warning: 'cb_tcp_last_ack' defined but not used [-Wunused-function]
ct_echo_event.c:241:12: warning: 'cb_tcp_time_wait' defined but not used [-Wunused-function]
ct_echo_event.c:251:12: warning: 'cb_tcp_after_finwait' defined but not used [-Wunused-function]
  CCLD     ct_echo_event
make: Leaving directory `git/netfilter.org/libnetfilter_conntrack/qa'
modprobe: FATAL: Module nfnetlink_cttimeout not found.
(UNKNOWN) [10.255.255.250] 7 (echo) : Connection refused
    [NEW] tcp      6 2 SYN_SENT src=10.255.255.249 dst=10.255.255.250 sport=55576 dport=7 [UNREPLIED] src=10.255.255.250 dst=10.255.255.249 sport=7 dport=55576
[DESTROY] tcp      6 src=10.255.255.249 dst=10.255.255.250 sport=55576 dport=7 [UNREPLIED] src=10.255.255.250 dst=10.255.255.249 sport=7 dport=55576
ct_echo_event: ct_echo_event.c:95: author_update: Assertion `(nlh->nlmsg_type & 0xFF) == IPCTNL_MSG_CT_NEW' failed.
qa/ct_echo_event.sh: line 56:  2182 Aborted                 ${dname}/ct_echo_event $NETNS $PRE_FIFO $POST_FIFO
qa/ct_echo_event.sh: line 62: qa_post_fifo: No such file or directory
qa/ct_echo_event.sh: line 65: qa_pre_fifo: No such file or directory
qa/ct_echo_event.sh: line 67: qa_post_fifo: No such file or directory
qa/ct_echo_event.sh: line 70: qa_pre_fifo: No such file or directory
qa/ct_echo_event.sh: line 72: qa_post_fifo: No such file or directory
Killed

Seems like this depends on inetd to provide tcp/udp echo services.
Thats fine, I don't have any objections.

The ICMP test passes when I remove tcp/udp test.

Could you please either remove the unused functions or provide some
comment in the commit message why these helpers are there, but currently
unused? (I see you commented out the calls).

[ the modprobe error is because I don't have cttimeout but it does appear to have no immediate
 ill effect ]

Thanks!
