From: Zhao yao <zhaoyao73@yahoo.com.cn>
Subject: death_by_timeout
Date: Wed, 13 Oct 2004 19:51:06 +0800 (CST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041013115106.79239.qmail@web53807.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

maillist gone wrong? these days no mails?
I have one question!

hi, developers!


 I have a question about clean_from_lists!

 In this function, we will delete conntrack hash from
hash table, but if
under smp,
 one cpu in early_drop, it will drop one conntrack
then call
death_by_timeout;
 another cpu in ip_ct_selective_cleanup, it will kill
the same conntrack
and then call death_by_timeout.

first cpu clean_from_lists, and then another cpu enter
clean_from_lists, it
found that this ct hash
is not in hash table(it can't found, just oops!).

I don't know i am right? this is just a example, i
mean is that possible?


thank you!

Best regards£°


_________________________________________________________
Do You Yahoo!? 
œ”” œ‰Ã´–°£ø—≈ª¢µÁ” ◊‘÷˙¿©»›£°
http://cn.rd.yahoo.com/mail_cn/tag/10m/*http://cn.mail.yahoo.com/event/10m.html
