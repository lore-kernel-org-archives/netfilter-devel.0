From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] [LIBNFNETLINK] Fix endless loop on unknown netfilter
 attributes.
Date: Thu, 09 Aug 2007 18:58:45 +0200
Message-ID: <46BB47C5.7030402@netfilter.org>
References: <46BA2092.20702@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: Marcus Sundberg <marcus@ingate.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46BA2092.20702@ingate.com>
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

Marcus Sundberg wrote:
> [LIBNFNETLINK] Fix endless loop on unknown netfilter attributes.
> 
> This prevents an endless loop when nfnl_check_attributes() sees
> an unknown attribute.

Applied. Thanks Marcus.

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.
