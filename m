From: qhou <qhou_acornsoft@sohu.com>
Subject: Q: Can I get handled on "conntrack" DESTROY, without ip_conntrack_destroyed()
Date: Thu, 27 Jun 2002 09:50:34 +0800 (CST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1270026.1025142634777.JavaMail.postfix@mailsrv10.mail.sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


There will be a conflict if we use ip_conntrack_destroyed() to handle it,
for ONLY one single function can register on it. AFAIK, it is used by the NAT...

I think if it is necessary to make a handle for it,
then I can release the private data in my module with ease,
or I should repeated implement the destroy algorithm.

Any IDEA is welcome,
Thanks
