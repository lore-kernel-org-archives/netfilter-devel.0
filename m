From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] H.323: Check range first in sequence extension
Date: Thu, 24 May 2007 20:55:38 +0200
Message-ID: <4655DFAA.10107@trash.net>
References: <20070517191757.1047E3DA1FB@jzhao.vivecode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@vivecode.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070517191757.1047E3DA1FB@jzhao.vivecode.com>
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

Jing Min Zhao wrote:
> Check range before checking STOP flag. This optimization may save a nanosecond or less :)


I'll queue this one for 2.6.23 since its a not too important
optimization.
