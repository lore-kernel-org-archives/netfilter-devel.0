From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_amanda: fix textsearch_prepare() error
	check
Date: Mon, 04 Jun 2007 13:41:12 +0200
Message-ID: <4663FA58.4050101@trash.net>
References: <20070603120030.GA876@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "Brian J. Murrell" <netfilter@interlinx.bc.ca>,
	netfilter-devel@lists.netfilter.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070603120030.GA876@APFDCB5C>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Akinobu Mita wrote:
> The return value from textsearch_prepare() needs to be checked
> by IS_ERR(). Because it returns error code as a pointer.


Good catch, applied. Thanks Akinobu.
