From: Sirine Chaitou <schit_2007@yahoo.fr>
Subject: How to use the tcp_info structure in linux/tcp.h
Date: Tue, 21 Aug 2007 09:32:05 +0200 (CEST)
Message-ID: <549896.28057.qm@web26609.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Dear All,
I am looking to:
1. how to tell linux to look exactly to the flags of a
TCP header
(struct tcphdr * tcp_hdr;
...
I want to access the tcp_hdr->flags field)

2. how to use the on the fly information existing in
linux/tcp.h.

Any Help?
Regards
Siri


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
