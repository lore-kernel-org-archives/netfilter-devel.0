From: "Juan Torres" <islero77@telefonica.net>
Subject: easy questions about matches implementation
Date: Wed, 4 Jun 2003 19:14:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000001c32abc$cb7a1620$0300000a@juan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter-devel" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

       
       Hello, maybe it's a very easy question, but I'm studying the
match ipt_multiport.c and I don't understand one thing:
       
       Why, in the last lines, it registers the match with
ipt_register_match (&multiport_match) and, in the next line, it
unregisters the match with ipt_unregister_match (&multiport_match)? How
it works? 
       
       Is it because we only register when we read a rule that uses the
multiport module, and just after we unregister again the match?
       
       What is the function of the last line MODULE_LINE ("GPL");?
       
       Where can I find more information about these questions? (I have
read the Netfilter Hacking HOWTO)
       
       
       Thank you very much for your help
       
       
       Now I write the last lines of the file ipt_multiport.c:
       
       
       static struct ipt_match multiport_match
       = { { NULL, NULL }, "multiport", &match, &checkentry, NULL,
THIS_MODULE };
       
       static int __init init(void)
       {
       	return ipt_register_match(&multiport_match);
       }
       
       static void __exit fini(void)
       {
       	ipt_unregister_match(&multiport_match);
       }
       
       module_init(init);
       module_exit(fini);
       MODULE_LICENSE("GPL");
             
        
