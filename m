From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_policy: remove dups in .family
Date: Tue, 19 Sep 2006 10:27:11 +0200
Message-ID: <450FA9DF.1030003@trash.net>
References: <20060919010619.GB5273@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20060919010619.GB5273@martell.zuzino.mipt.ru>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Dobriyan wrote:
> sparse "defined twice" warning

Thanks, applied with some manual fixup. Please base netfilter patches on
the net-2.6.19 tree.

