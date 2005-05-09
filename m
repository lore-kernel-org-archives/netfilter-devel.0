From: cranium2003 <cranium2003@yahoo.com>
Subject: Urgent SNAT help required
Date: Mon, 9 May 2005 01:30:17 -0700 (PDT)
Message-ID: <20050509083018.20467.qmail@web41413.mail.yahoo.com>
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
         I want to execute my code at
NF_IP_POST_ROUTING. For that First i want to know
which functions are executing at NF_IP_POST_ROUTING
Hook. Then i have enabled SNAT and I have wrriten code
at NF_IP_POST_ROUTING but i want to get outgoing
packets' IP address as new one SNAT'ed IP address not
the one that is before SNAT? How can i do that?
         I observe that my code and SNAT are executing
at same HOOK NF_IP_POST_ROUTING. But my code is
executed first and then SANT is doen but how to
reverse that?
regards,
cranium


		
Yahoo! Mail
Stay connected, organized, and protected. Take the tour:
http://tour.mail.yahoo.com/mailtour.html
