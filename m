From: =?ISO-8859-1?Q?=D6=A3=B4=AB=B2=A8?= <zhengcb@netpower.com.cn>
Subject: a problem on visiting DMZ servers when apply DNAT?
Date: Sun, 16 Jun 2002 12:10:36 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206161211650.SM00796@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

we use linux as the firewall. we have a web server,as we made a DNAT rule on the firewall,the people can visit it from internet by address 202.38.128.1(just a example,not real). 

            (202.38.128.1)
internet----------firewall------------localhost
                    |                (192.168.0.10)
                    |
                 www server
                 (10.0.0.2)

the problem is the localhost can no longer visit the web server with the same IP(we also have a dns server,people visit that with domain name). we can only visit it by the IP 10.0.0.2. the people don't like that. but i don't know how to solve the problem.
any idea? thanks in advance.

chuanbo zheng
