From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: Fix invalid return values from sctp_new
Date: Mon, 20 Sep 2004 11:40:13 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414EA57D.9070809@trash.net>
References: <414E9493.3020800@trash.net> <200409201408.35538.immidi@spymac.com>
	<414E9CC2.2090805@trash.net> <200409201456.19496.immidi@spymac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kiran Kumar Immidi <immidi@spymac.com>
In-Reply-To: <200409201456.19496.immidi@spymac.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Kiran Kumar Immidi wrote:

>http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_proto_tcp.c?v=2.6.8.1#L240
>
>I still find it in 2.6.8.1
>  
>

You're right. Seems like it was silently fixed during the
skb_header_pointer conversion.

Regards
Patrick
