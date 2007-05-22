From: "Morten Isaksen" <misak@misak.dk>
Subject: libnfnetlink_conntrack performance
Date: Tue, 22 May 2007 23:02:42 +0200
Message-ID: <7194302c0705221402k14bfe9eco7ecc98910eaa1c87@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi!

Do anyone have som experience with the performance of libnfnetlink_conntrack?

I am using it to track and log NFCT_T_NEW and NFCT_T_DESTROY events. I
am testing it on a firewall with about 15 Mbit/s traffic and 18-22K
entries in ip_conntrack. The only difference I can spot so far is 300
more context switches pr. sec than usual.

The events are collected in batches of 7 and then sent in an UDP
packet to a log server.

-- 
Morten Isaksen
http://www.misak.dk/blog/
