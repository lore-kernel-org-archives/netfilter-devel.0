From: Scott MacKay <scottmackay@yahoo.com>
Subject: netfilter language
Date: Fri, 18 Apr 2003 04:39:06 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030418113906.98028.qmail@web13906.mail.yahoo.com>
References: <200304181524.44951.fabrice@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200304181524.44951.fabrice@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
    I have been playing with the userspace component
of iptables, making my own QUEUE application, with
varying levels of success (as seen in previous
emails).  Because of my needs which I don't think can
be fulfilled in a QUEUE, I am thinking of looking into
working more in the kernel level netfilter.  
    I was wondering, can C++ be used in developing
netfilter modules, or is it really limited more to C? 
The material I would shift into a netfilter area is
pretty simple, so I can easily convert it to C if
needed.  Also, are there any references to the order
in which my work would be called?  Because of it's
nature, I would need to be called before any other
handler module (especially conn track).  Thanks in
advance!

-Scott

__________________________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo
http://search.yahoo.com
