From: Anand S <mailsanand@yahoo.com>
Subject: using spin_lock in the extended iptables targert
Date: Wed, 5 Jun 2002 22:07:49 -0700 (PDT)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606050749.9386.qmail@web21310.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

i have written a new target for iptables
i write the captured packets to my device driver's
buffer, to have proper access to the buffer i need to
protect the addition and deletion of buffers 

which of the follwing two functions( or any other)
should be used for locking

spin_lock_irqsave()
spin_lock_bh()

any help or advice is appriciated
thanx


__________________________________________________
Do You Yahoo!?
Yahoo! - Official partner of 2002 FIFA World Cup
http://fifaworldcup.yahoo.com
