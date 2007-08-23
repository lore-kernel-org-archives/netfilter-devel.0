From: "Yakov Lerner" <iler.ml@gmail.com>
Subject: netfilter hook does not see some packets ...
Date: Thu, 23 Aug 2007 15:23:16 +0300
Message-ID: <f36b08ee0708230523s5d1aefd0l40166a5d37295f98@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

I have a situation where my kernel module that registers the
nf hooks does does not see some packets. Those packets seems to be
those that are REDIRECTed by the following iptables rule:

*nat
:WEBFILTER-NAT - [0:0]
-A PREROUTING -j WEBFILTER-NAT
-A WEBFILTER-NAT -s 192.168.69.0/255.255.255.0 -p tcp -m tcp --dport
80 -j WF-8080
-A WF-8080 -p tcp -j REDIRECT --to-ports 8080
*filter
-A FORWARD -s 192.168.69.0/255.255.255.0 -j QUEUE

I hook 4 hooking points in my module (forward, local-in, local-out,
pre-routing).
My hooking priority is NF_IP_PRI_FIRST.

What is the reason that packets are not seen by my module ? How do I fix this ?

Thanks
Yakov
