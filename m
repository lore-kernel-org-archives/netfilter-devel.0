From: =?gb2312?q?Jon=20Zeng?= <jon_zeng@yahoo.com.cn>
Subject: A bug in nf_reinject()?
Date: Thu, 29 Jan 2004 11:49:52 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040129034952.63721.qmail@web15202.mail.bjs.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8bit
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

Hello, 

It seems that the line tagged '-' should be the one
tagged '+',
am I right?

void nf_reinject(struct sk_buff *skb, struct nf_info
*info,
		 unsigned int verdict)
{
	......

	list_for_each_rcu(i, &nf_hooks[info->pf][info->hook])
{
		if (i == elem) 
  			break;
  	}
  
-	if (elem == &nf_hooks[info->pf][info->hook]) {
+	if (i == &nf_hooks[info->pf][info->hook]) {
		/* The module which sent it to userspace is gone. */
		NFDEBUG("%s: module disappeared, dropping
packet.\n",
			__FUNCTION__);
		verdict = NF_DROP;
	}

	......
}

_________________________________________________________
Do You Yahoo!? 
繁华世界里，让我看清你
http://cn.rd.yahoo.com/mail_cn/tag/?http://cn.surveys.yahoo.com/cn_user_profile_study_dec2003
