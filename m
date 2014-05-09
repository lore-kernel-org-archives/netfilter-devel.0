From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [contrack-tools PATCH] build: do not compile nfct if we disabled
 cttimeout
Date: Fri, 9 May 2014 13:29:59 +0200
Message-ID: <20140509112959.GA3812@localhost>
References: <1399543345-3634-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter dev <netfilter@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Hangbin Liu <liuhangbin@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1399543345-3634-1-git-send-email-liuhangbin@gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 08, 2014 at 06:02:25PM +0800, Hangbin Liu wrote:
> If we do not have libnetfilter_cttimeout and disabled cttimeout, conntrack-tools
> will compile fail because nfct.c include nfnetlink_cttimeout.h. Fix it by only
> compile nfct when we have enabled cttimeout

Strange. The nfnetlink_cttimeout.h file is cached inside the
conntrack-tools tree:

conntrack-tools/include/linux/netfilter/nfnetlink_cttimeout.h

Here this compiles fine with my current tree and using:

./configure --prefix=/usr --disable-cthelper --disable-cttimeout

Please, investigate this issue a bit further.
