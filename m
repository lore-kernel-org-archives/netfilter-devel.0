From: Pablo Neira <pablo@eurodev.net>
Subject: comments about ip_conntrack_in function
Date: Wed, 03 Mar 2004 01:44:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40452A57.3060209@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald and list,

Having a look at the ip_conntrack_in function (please, see below), I 
noticed that:

a) I didn't find any helper that returns -1.

b) I didn't find a function proto->packet (which actually calls its 
respective protocol specific function) that returns NF_DROP. So the 
condition alike(NF_DROP) is always true. In fact, all the functions that 
I had a look at return -1 and NF_ACCEPT.

So, is considering that proto->packet is always going to return 
NF_ACCEPT and -1 an invalid assumption? Maybe the possible return values 
of this function could be restricted a bit more.
Anyway, in which case does returning NF_DROP make sense here?.

c) I don't know so much about the set_bit function and its 
implementation but, while setting the status of a conntrack already 
inserted, don't we need to write_lock the conntrack hash table?

--- snipped from ip_conntrack_in() ------
...
        ret = proto->packet(ct, *pskb, ctinfo);
        if (ret == -1) {
                /* Invalid */
                nf_conntrack_put((*pskb)->nfct);
                (*pskb)->nfct = NULL;
                return NF_ACCEPT;
        }

        if (ret != NF_DROP && ct->helper) {
                ret = ct->helper->help(*pskb, ct, ctinfo);
                if (ret == -1) {
                        /* Invalid */
                        nf_conntrack_put((*pskb)->nfct);
                        (*pskb)->nfct = NULL;
                        return NF_ACCEPT;
                }
        }
        if (set_reply)
                set_bit(IPS_SEEN_REPLY_BIT, &ct->status);

        return ret;

-------- end ------------

best regards,
Pablo
