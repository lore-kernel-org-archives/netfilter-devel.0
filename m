From: =?gb2312?q?Jon=20Zeng?= <jon_zeng@yahoo.com.cn>
Subject: a bug in nf_reinject()?
Date: Wed, 4 Feb 2004 20:06:30 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040204120630.37101.qmail@web15203.mail.bjs.yahoo.com>
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

It seems that the line tagged '-' should be the line
tagged '+'.
Am I right?

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
完全免费的雅虎电邮，马上注册获赠额外60兆网络存储空间
http://cn.rd.yahoo.com/mail_cn/tag/?http://cn.mail.yahoo.com
