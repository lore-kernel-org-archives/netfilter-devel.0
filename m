From: Pablo Neira <pablo@eurodev.net>
Subject: ip_ct_refresh lock issue
Date: Sat, 28 Feb 2004 15:18:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4040A334.3020808@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi list,

I can't see the reason why in ip_ct_refresh the conntrack is locked to 
modify an not confirmed conntrack timeout.

It isn't inserted in the conntrack table yet, so why do we need to do 
that? any possible race here?

        WRITE_LOCK(&ip_conntrack_lock);
        /* If not in hash table, timer will not be active yet */
        if (!is_confirmed(ct))
                ct->timeout.expires = extra_jiffies;
        else {
                /* Need del_timer for race avoidance (may already be 
dying). */
                if (del_timer(&ct->timeout)) {
                        ct->timeout.expires = jiffies + extra_jiffies;
                        add_timer(&ct->timeout);
                }
        }
        WRITE_UNLOCK(&ip_conntrack_lock);
}

best regards,
Pablo
