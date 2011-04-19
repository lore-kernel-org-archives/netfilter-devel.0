From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] netfilter: netfilter update
Date: Tue, 19 Apr 2011 11:28:03 -0700 (PDT)
Message-ID: <20110419.112803.102559508.davem@davemloft.net>
References: <1303223492-13549-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1303223492-13549-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: kaber@trash.net
Date: Tue, 19 Apr 2011 16:31:29 +0200

> following is a small netfilter update for net-next, containing:
> 
> - a patch from Eric to remove some atomic ops in the *tables fastpath
> 
> - removal of an unnecessary ifdef from IPVS by Simon
> 
> - SCTP and UDPLITE support for ipset, from Jozsef
> 
> Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git master

Pulled, thanks!
