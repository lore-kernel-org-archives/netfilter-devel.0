From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: simplify init/uninit of
 L4 protocol trackers
Date: Fri, 28 Oct 2016 11:03:35 +0200
Message-ID: <20161028090335.GA23286@salvia>
References: <2b862e9bc046bc42def1a56611265ddbc640fddd.1477643522.git.dcaratti@redhat.com>
 <20161028084752.GA6305@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752374AbcJ1JDu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 05:03:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22A8026E14
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 11:03:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1D57203E1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 11:03:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0CD6BAC2A
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 11:03:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161028084752.GA6305@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 28, 2016 at 10:47:52AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 28, 2016 at 10:42:09AM +0200, Davide Caratti wrote:
> > modify registration and deregistration of layer-4 protocol trackers to
> > facilitate inclusion of new elements into the current list of builtin
> > protocols. Both builtin (TCP, UDP, ICMP) and non-builtin (DCCP, GRE, SCTP,
> > UDPlite) layer-4 protocol trackers usually register/deregister themselves
> > using consecutive calls to nf_ct_l4proto_{,pernet}_{,un}register(...).
> > This sequence is interrupted and rolled back in case of error; in order to
> > simplify addition of builtin protocols, the input of the above functions
> > has been modified to allow registering/unregistering multiple protocols.
> 
> Applied, thanks Davide.

Wait, let me get back to you with a bit more feedback. There are a few
nitpicks, and looking at this again, I guess we can improve
maintainability by splitting code into smaller functions.

Will get back to you in a while with more feedback, sorry,
