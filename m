From: octane indice <octane@alinto.com>
Subject: firewall with failover - ct_sync ?
Date: Mon, 24 Apr 2006 18:24:16 +0200
Message-ID: <1145895856.444cfbb0eee53@webmail.alinto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello

I'm trying to experiment a firewall cluster under linux like 
carp+pfsync under openBSD.

1. does ct_sync works?
I asked on the netfilter-failover mailing list where someone tolds me not (but 
the mailing lists seems abandoned).

2. I found the web page:
http://svn.netfilter.org/netfilter/trunk/netfilter-ha/README
But it makes references to kernel 2.4.26 and CVS.
2. a) Must I use quilt? 
2. b) Where I grab the patch files?

3. Is there another documentation?

4. the site http://vvv.barbarossa.name/files/ct_sync/
gives two patch for the 2.6.16 kernel.
Which one have I to use? both?

5. The link beetween the two machines must be an ethernet link? 
I have old boxes with two PCI port only, but parrallel link is OK with plip. For 
testing would it be OK? (I just want to test functionnality, not the throughput)

Thanks

"Ce Caillou-là" un conte en téléchargement gratuit sur http://www.Manuscrit.com
