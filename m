From: =?iso-8859-1?q?Jambunathan=20Kalyanasundaram?= <k_jambunathan@yahoo.co.uk>
Subject: libiptc question
Date: Wed, 25 Feb 2004 04:29:20 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040225042920.21925.qmail@web25104.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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

A quick question.

I would like to add a SNAT rule ( with a TCP protocol
match ) programmatically to iptables. 

So will calling iptc_append_entry() with suitably
filled ipt_entry ( just the same as the one that
iptables would pass across ) work. Are there any other
elegant methods ?

If someone could reply off hand to my query it will
save me a lot of re-engg. work.

Thanks in advance,
Jambunathan K.





	
	
		
___________________________________________________________
Yahoo! Messenger - Communicate instantly..."Ping" 
your friends today! Download Messenger Now 
http://uk.messenger.yahoo.com/download/index.html
