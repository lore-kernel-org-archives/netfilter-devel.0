From: Christian Hentschel <chentschel2@arnet.com.ar>
Subject: Questions on conntrack
Date: Wed, 09 Feb 2005 23:31:19 -0300
Message-ID: <1108002679.1426.11.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hi, 
	I'm trying to write a new UDP conntrack helper for netfilter and
looking at existing code, i have a few questions. 

1). Do I need to check for the full UDP header?.. i can see some tcp
helper that do it, but udp helpers does not.

        th = skb_header_pointer(skb, skb->nh.iph->ihl*4, sizeof(_tcph),
&_tcph);
        if (th == NULL)
                return NF_ACCEPT;

2). After that, some (TCP) helpers check for data avail. doing something
like this:

        dataoff = skb->nh.iph->ihl*4 + th->doff*4;
        /* No data? */
        if (dataoff >= skb->len) {
                DEBUGP("ftp: skblen = %u\n", skb->len);
                return NF_ACCEPT;
        }
        datalen = skb->len - dataoff;

Again, ie, tftp helper (UDP) does not. 

3). The last one ;).. is if someone can tell me why is the lock for. Is
that because we can't use data directly from skb?.

        LOCK_BH(&ip_ftp_lock);
        fb_ptr = skb_header_pointer(skb, dataoff, skb->len - dataoff,
ftp_buffer);


Sorry for my english, and if they r stupid questions. 
Thanks in advance. 

Christian Hentschel.


-- 
