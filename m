From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 12:14:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40ADD679.7030906@eurodev.net>
References: <Pine.LNX.4.33.0405201307440.5246-100000@blackhole.kfki.hu> <40AD3CB7.1070107@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40AD3CB7.1070107@eurodev.net>
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

> d) We could move up WRITE_UNLOCK(&tcp_lock) just before timeout is 
> updated.


oh, I think this comment is not so clear, I meant:

        timeout = conntrack->proto.tcp.retrans >= ip_ct_tcp_max_retrans
                  && *tcp_timeouts[new_state] > 
ip_ct_tcp_timeout_max_retrans ?
                  ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state]
+     WRITE_UNLOCK(&tcp_lock);

regards,
Pablo
