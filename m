From: Patrick McHardy <kaber@trash.net>
Subject: Re: CLASSIFY target in POSTROUTING only?
Date: Fri, 04 Mar 2005 12:45:38 +0100
Message-ID: <42284A62.6040305@trash.net>
References: <20050304112306.29481.qmail@web90007.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Peter Lenci <peterlenci@yahoo.ca>
In-Reply-To: <20050304112306.29481.qmail@web90007.mail.scd.yahoo.com>
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

Peter Lenci wrote:
> Hi all
> 
> The CLASSIFY extension can only be used in the POSTROUTING chain of the
> mangle table. Is there a technical reason for this or is it just an aid
> to prevent misconfiguration? In particular I'd like to use the CLASSIFY
> target in the PREROUTING table (in combination with ingress tcp shaping
> with the IMQ device).

The CLASSIFY target is useable in LOCAL_OUT/FORWARD/POST_ROUTING.
PRE_ROUTING is not possible because the value will be overwritten
in ip_forward(). For IMQ you could simply remove that restriction.

Regards
Patrick
