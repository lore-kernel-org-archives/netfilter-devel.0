From: cranium2003 <cranium2003@yahoo.com>
Subject: Help in writing neteork device driver
Date: Mon, 6 Dec 2004 23:13:51 -0800 (PST)
Message-ID: <20041207071351.14229.qmail@web41412.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>
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

hello,
I am writing a virtual network device driver in which
i am setting hard_header 22 instead 14. i have some
queries about it.
1) is that thing possible (hard_header=22)?
2) does virtual device driver can take eth0 control
and send modified packets?
3) i want to send extra info with packets by making
hard header 22 so is there any alignement problem?
any other solution/help is welcome.
regards,
cranium



		
__________________________________ 
Do you Yahoo!? 
Meet the all-new My Yahoo! - Try it today! 
http://my.yahoo.com 
 
