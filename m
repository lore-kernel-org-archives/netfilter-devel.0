From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: skbuff replication [long]
Date: Fri, 18 Feb 2005 09:12:13 -0800 (PST)
Message-ID: <20050218171213.2914.qmail@web30202.mail.mud.yahoo.com>
References: <20050218145921.61380.qmail@web30206.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050218145921.61380.qmail@web30206.mail.mud.yahoo.com>
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

Nevermind, ignore my huge ramblings.

I do indeed need to keep a copy of the unaltered
buffer, but all I need is a skb_copy() in the ipv4
mangling function to do this.  If I realize the
contents change, I skb_copy it, toss out the old
reference, update the new copy and the retransmit is
happy.  The original ip_queue probably should have
done this in addition to the skb_trim, but oh well.

-Scott


	
		
__________________________________ 
Do you Yahoo!? 
Yahoo! Mail - You care about security. So do we. 
http://promotions.yahoo.com/new_mail
