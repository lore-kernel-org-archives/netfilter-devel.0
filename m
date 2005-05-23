From: Michal Rokos <michal@rokos.info>
Subject: Re: [PATCH NF_CONNTRACK 1/9]: Fix multiple problems with TCP window
	tracking
Date: Mon, 23 May 2005 15:46:58 +0200
Message-ID: <200505231546.58751.michal@rokos.info>
References: <200505230617.j4N6HROa027617@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200505230617.j4N6HROa027617@toshiba.co.jp>
Content-Disposition: inline
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

Hello,

>>>>> "YK" == Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> writes:
YK>
YK> This patch follows the recent changes to ip_conntrack.
YK>

could I ask you against what is this patch?

I'm using 
http://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/nf_conntrack and 
I'm getting rejects when applying this patch...

Namely:
***************
*** 515,521 ****

  static int tcp_in_window(struct ip_ct_tcp *state,
                           enum ip_conntrack_dir dir,
-                          unsigned int *index,
                           const struct sk_buff *skb,
                         unsigned int dataoff,
                           struct tcphdr *tcph,
--- 523,529 ----

  static int tcp_in_window(struct ip_ct_tcp *state,
                           enum ip_conntrack_dir dir,
+                          unsigned int index,
                           const struct sk_buff *skb,
                         unsigned int dataoff,
                           struct tcphdr *tcph,
but I have there: static int tcp_in_window(struct nf_ct_tcp *state,

When I tried to apply '[PATCH NF_CONNTRACK 1/9]: unify common symbols of 
{ip,nf}_conntrack' you posted 2005-03-22, I'm getting rejects too...

So it seems I follow odd repository.

Do you have any hint what repository should I track?

Thank you.

 Michal
