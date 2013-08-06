From: Phil Oester <kernel@linuxace.com>
Subject: Re: state match incompatibilty across versions
Date: Tue, 6 Aug 2013 15:33:54 -0700
Message-ID: <20130806223354.GA20287@linuxace.com>
References: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34324 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3HFWdv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:33:51 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so724099pdi.13
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Aug 2013 15:33:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 06, 2013 at 02:23:44PM -0400, Laurence J. Lane wrote:
> Debian Bug#718810 reports a problem with the state match across
> iptables versions. The following rules were created with the same
> states using 1.4.14. The state information on the state match do now
> show with 1.4.19.1's iptables-save or " iptables -L". The conntrack
> match's ctstate works as expected with the upgrade.

Can't seem to reproduce the problem here:

# /usr/local/ipt1414/sbin/iptables -V
iptables v1.4.14
# /usr/local/ipt1414/sbin/iptables -A foo -m state --state RELATED,ESTABLISHED -j ACCEPT
# /usr/local/ipt1414/sbin/iptables -nvL foo
Chain foo (0 references)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED


# /usr/local/iptables/sbin/iptables -V
iptables v1.4.19.1
# /usr/local/iptables/sbin/iptables -nvL foo
Chain foo (0 references)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED


Perhaps kernel revision sensitive?

Phil
