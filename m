From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 01:18:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AD3CB7.1070107@eurodev.net>
References: <Pine.LNX.4.33.0405201307440.5246-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0405201307440.5246-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Jozsef Kadlecsik wrote:

>It's funny: (practically) connection tracking itself does not drop
>packets, it leaves the administrator to do the dirty job by setting up
>explicit rules to drop INVALID packets (or implicitly, by letting trough
>only valid packets) :-)
>  
>

sorry! I missed that... I should know better iptables !:-)

>
>Some tests are done before checking the window boundaries from good
>reasons: checking special cases when packets are possibly (mostly!) out of
>window. You cannot move them behind the boundary checkings.
>  
>

ok, I also missed that... more issues:

a) Sometimes we destroy the conntrack calling 
conntrack->timeout.function((unsigned long)conntrack) but we are 
returning -NF_ACCEPT, so we are calling implicitely nf_conntrack_put 
from conntrack core, could we have any unexpected problem?

b) We don't need to set assured bit all the time, I think that I told 
you, well if so, sorry for repeating me.

         } else if ((old_state == TCP_CONNTRACK_SYN_RECV
                    || old_state == TCP_CONNTRACK_ESTABLISHED)
-                   && new_state == TCP_CONNTRACK_ESTABLISHED)
+                 && new_state == TCP_CONNTRACK_ESTABLISHED
+                 && !test_bit(IPS_ASSURED_BIT, &conntrack->status)) {

c) In the TCP_CONNTRACK_SYN_SENT case, we saw a SYN packet while staying 
in state TIME_WAIT, so there's a reopened connection. Why do we destroy 
the conntrack and don't recycle /reuse this conntrack? I mean, 
reinitilize all the fields and let it continue its travel through the 
tcp tracking of instead of returning NF_REPEAT.

d) We could move up WRITE_UNLOCK(&tcp_lock) just before timeout is updated.

e) I'm not sure if it's worthy optimizing this case. In tcp_new, we are 
checking if a packet is clean as well as size of tcp header, then in 
tcp_packet we will do the same, so we are doing twice the same checking. 
If we consider that general case is that packets are clean, will be this 
double check worthy?

thanks Jozsef!,
insidious Pablo
