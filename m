From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug in icmp tracking?
Date: Tue, 09 Mar 2004 21:35:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404E2A8E.1020204@trash.net>
References: <404E1E90.3060509@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <404E1E90.3060509@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:
> Hi list,
> 
> I sent some ICMP echo's request and I received the echo's reply with no 
> problems but the conntrack doesn't track them.
> 
> This is because the value returned by icmp_error_track called from 
> ip_conntrack_in.
> 
> snipped from icmp_error_track(...):
> 
> 514         if (inside.icmp.type != ICMP_DEST_UNREACH
> 515             && inside.icmp.type != ICMP_SOURCE_QUENCH
> 516             && inside.icmp.type != ICMP_TIME_EXCEEDED
> 517             && inside.icmp.type != ICMP_PARAMETERPROB
> 518             && inside.icmp.type != ICMP_REDIRECT)
> 519                 return NULL;
> 
> I also had a look at the docs and I didn't find anything like "icmp are 
> not tracked because of something...".
> 
> So, is this a bug or a feature?

Neither of both, you looked in the wrong place ;)
This function only tracks ICMP errors, ICMP echo-request messages
are handled by ip_conntrack_proto_icmp .. the conntrack entry
itself is removed immediately when there are no more outstanding
replies.

Regards
Patrick

> 
> regards,
> Pablo
> 
