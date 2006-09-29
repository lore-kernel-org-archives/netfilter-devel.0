From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libnfnetlink
Date: Fri, 29 Sep 2006 16:18:35 +0200
Message-ID: <451D2B3B.7070604@trash.net>
References: <1159531818.451d0d2a31b47@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maik Hentsche <netfilter@mm-double.de>
In-Reply-To: <1159531818.451d0d2a31b47@www.domainfactory-webmail.de>
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

Maik Hentsche wrote:
> Hello Pablo, hello readers of the list,
> I found another bug in libnfnetlink. The comment of nfnl_recv states, in
> case of success 0 is returned. In fact at success the returnvalue of
> recvfrom is returned, which is the number of received bytes
> (libnfnetlink_recv_comment.patch). The second issue is a little more
> serious. The comment states, in case of an error, errno is set when in
> fact it is not. I appended a patch for two occurences, but I since I
> don't know, in which case addrlen might be != sizeof(peer) and what
> peer.nl_pid means (and therefore why it is a problem, if it's not 0)
> two error cases without appropriate errno value still exist.

addrlen != sizeof(peer) should never happen. I can't think of anything
better than EINVAL. nl_pid != 0 means the message originated in
userspace and some other program is trying to feed us messages.
We could handle this by just calling recvmsg again. But this is mainly
because I can't think of a proper errno code for this either :)
