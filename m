From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT differences in 2.6.12.2
Date: Fri, 08 Jul 2005 03:03:22 +0200
Message-ID: <42CDD0DA.20303@trash.net>
References: <42CADB0F.5010804@metaloft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dirk Morris <dmorris@metaloft.com>
In-Reply-To: <42CADB0F.5010804@metaloft.com>
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

Dirk Morris wrote:
> notice how the syn/ack comes from eve instead of bob, and it only 
> matches 1 packet (the SYN I assume)
> I suspect the syn/ack isnt matching in the conntrack table for some reason?
> Could it be because the syn is marked, but the syn/ack isnt?

No, that doesn't affect association with a conntrack entry. Please retry
after doing "echo 255 > /proc/sys/net/ipv4/netfilter/ip_ct_log_invalid"
and "modprobe ipt_LOG".

Regards
Patrick
