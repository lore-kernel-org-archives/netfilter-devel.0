From: Patrick McHardy <kaber@trash.net>
Subject: Re: default value of nf_conntrack_tcp_timeout_close_wait
Date: Wed, 04 Apr 2007 17:30:05 +0200
Message-ID: <4613C47D.40001@trash.net>
References: <20070404122314.GP657@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Joakim Axelsson <gozem@gozem.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070404122314.GP657@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> Hi,
> 
> I've notices that the default value of
> /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait (atleast in
> kernel 2.6.20.4) is only set to 60 seconds. CLOSE_WAIT is the state where
> one side has sent a FIN but not the other. Meaning we can still send data in
> one direction. This is a state which can live a long time. Much longer than
> just 60 seconds.
> 
> I did some googling on the issue to find previous discussions on netfilter
> on the subject, and i can see that an old patch was sent in 2003 to kernel
> to fix this problem. I can only guess that the newer conntrack code brought
> the bug back:
> http://www.linuxarkivet.se/mlists/netfilter-devel/0310/msg00016.html


No, it was changed back without much explanation by this commit (from
the history.git tree):

[NETFILTER]: Sanitize ip_ct_tcp_timeout_close_wait value, from 2.4.x

---
commit b3cf20c77584ce8268be77032d305fe46da09ac6
tree 7c9737e62b90eb5b8c2378779f4ccb2d211dfdce
parent 474669a2743d375e7db3f0e4670c184335a38aee
author Harald Welte <laforge@netfilter.org> Tue, 02 Dec 2003 19:57:05 -0800
committer Linus Torvalds <torvalds@home.osdl.org> Tue, 02 Dec 2003
19:57:05 -0800

-unsigned long ip_ct_tcp_timeout_close_wait =    3 DAYS;
+unsigned long ip_ct_tcp_timeout_close_wait =   60 SECS;
