From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 -stable-3.12] netfilter: nf_conntrack: fix RCU race
 in nf_conntrack_find_get
Date: Fri, 11 Sep 2015 14:37:31 +0200
Message-ID: <20150911123731.GA5728@salvia>
References: <1441974368-5399-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441974368-5399-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Sep 11, 2015 at 02:26:07PM +0200, Pablo Neira Ayuso wrote:
> From: Andrey Vagin <avagin@openvz.org>
> 
> [ Upstream commit cb585e1b1d072d1d7caebc649364b9c46c27ea8f ]

For kernel 3.12 stable maintainer:

Wrong upstream, this should be c6825c0976fa7893692e0e43b09740b419b23c09.
