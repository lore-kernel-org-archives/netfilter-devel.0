From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: [PATCH]: Fix invalid return values from sctp_new
Date: Mon, 20 Sep 2004 14:56:19 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409201456.19496.immidi@spymac.com>
References: <414E9493.3020800@trash.net> <200409201408.35538.immidi@spymac.com>
	<414E9CC2.2090805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <414E9CC2.2090805@trash.net>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 20 September 2004 14:32, Patrick McHardy wrote:

> Thanks. The others are fine, and I can't find an old version of
> ip_conntrack_proto_tcp where it returned -1.

http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_proto_tcp.c?v=2.6.8.1#L240

I still find it in 2.6.8.1
-- 
Regards,
Kiran Kumar Immidi
