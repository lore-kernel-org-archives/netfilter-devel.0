From: Scott MacKay <scottmackay@yahoo.com>
Subject: QUEUE both ipv4 and ipv6?
Date: Tue, 13 Jul 2004 03:47:54 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040713104754.35592.qmail@web13906.mail.yahoo.com>
References: <200407131000.46777.Antony@Soft-Solutions.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200407131000.46777.Antony@Soft-Solutions.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Curious, not having it set up yet, but does
ipv6tables's QUEUE and iptable's QUEUE both send
packets to a single userspace QUEUE program?  It looks
like ipv6 uses ipv4's ip_queue.h header, so I would
think so...

-Scott


		
__________________________________
Do you Yahoo!?
Take Yahoo! Mail with you! Get it on your mobile phone.
http://mobile.yahoo.com/maildemo 
