From: <zrzeng@sohu.com>
Subject: nf_reinject() buggy?
Date: Tue, 20 Jan 2004 09:37:14 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4926736.1074562635922.JavaMail.postfix@mx16.mail.sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

in nf_reinject(), we have

void nf_reinject(struct sk_buff *skb, struct nf_info *info,
		 unsigned int verdict)
{
	struct list_head *elem = &info->elem->list;
	struct list_head *i;

           ......

	list_for_each_rcu(i, &nf_hooks[info->pf][info->hook]) {
		if (i == elem) 
  			break;
  	}
  
--->	if (elem == &nf_hooks[info->pf][info->hook]) {
		/* The module which sent it to userspace is gone. */
		NFDEBUG("%s: module disappeared, dropping packet.\n",
			__FUNCTION__);
		verdict = NF_DROP;
	}

          ......
}

I think the statement tagged "--->" should be 

           if (i == &nf_hooks[info->pf][info->hook]) {

Am I right?

regards
