From: A K A <gello666@yahoo.com>
Subject: Race Conditions
Date: Wed, 19 Feb 2003 21:37:22 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030220053722.24368.qmail@web13104.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I have developed a module and in the init_module
function i register two functions to two hooks
-NF_IP_LOCAL_IN and NF_IP_POST_ROUTING. In the two
functions i am acesssing a global data structure. Is
it possible for me to have race condition while
accessing the data structure or can I be sure that
while one function is executing another will not
because they are both running at the same IRQ level
which is below the schedular, and hence cannot
interupt each other. Is this assumption correct.

any coments, suggestions and pointers are appreciated.

regards,
Asad


__________________________________________________
Do you Yahoo!?
Yahoo! Tax Center - forms, calculators, tips, more
http://taxes.yahoo.com/
