From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: Fix invalid return values from sctp_new
Date: Mon, 20 Sep 2004 11:02:58 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414E9CC2.2090805@trash.net>
References: <414E9493.3020800@trash.net> <200409201408.35538.immidi@spymac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kiran Kumar Immidi <immidi@spymac.com>
In-Reply-To: <200409201408.35538.immidi@spymac.com>
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

>  This seems fair. But the place I copied this from 
>[ ip_conntrack_proto_tcp.c:tcp_new() ]  also needs to be fixed I guess..
>  
>

Thanks. The others are fine, and I can't find an old version of
ip_conntrack_proto_tcp where it returned -1.

Regards
Patrick
