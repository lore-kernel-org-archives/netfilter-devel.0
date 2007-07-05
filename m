From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] Add checking of out-of-range on Choices' index
	values
Date: Thu, 05 Jul 2007 20:29:51 +0200
Message-ID: <468D389F.80100@trash.net>
References: <20070704164952.834B114369A@jzhao.vivecode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@vivecode.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070704164952.834B114369A@jzhao.vivecode.com>
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
> Choices' index values may be out of range while still encoded in the fixed length bit-field. This bug may cause access to undefined types (NULL pointers) and thus crashes (Reported by Zhongling Wen).
> 
> This patch also adds checking of decode flag when decoding SEQUENCEs.


Thanks for fixing this so quickly, applied. I'll also push the
patch to -stable.
