From: qhou <qhou_acornsoft@sohu.com>
Subject: Re:Warm hearted man, Could you give me a suggestion on where to post this develop question of _NETFILTER_
Date: Mon, 1 Jul 2002 12:25:58 +0800 (CST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <6021918.1025497558149.JavaMail.postfix@mailsrv10.mail.sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Let me tell you, poor guy:
Why they didn't reply is because they are busy working on their "difficulties".
And they have perhaps already replied the message, but they even have no time to send out the mail.

Take pains...

SIGH


-----  т╜нд  -----
From: qhou 
To: qhou 
Subject: Warm hearted man, Could you give me a suggestion on where to post this develop question of _NETFILTER_
Sent: Fri Jun 28 14:33:25 CST 2002

> Perhaps the question for you is very easy.
> But I really don't know where to post yours easy my question on,
> PLEASE AT LEAST give me any suggestion on where to post it...OR more...
> 
> Thanks in advance...very much
> 
> Yours honesty...
> 
> > I have a requirement:
> > =====================
> > 1.When a conntrack is created, I'll allocate memory for my private data, if the associated connect is what I am interested on.
> > 2.And as the conntrack is destroyed for the connect is absolutely closed or timeout, I'll then release the memory of my private data.
> > 
> > The note(1) is easy to be done, but note(2) in some way is much more complex.
> > 
> > Currently I have two ideas on note(2):
> > ======================================
> > 1.Register a handle of the "void (*ip_conntrack_destroyed)()" in "ip_conntract_core.c" on my module's init function.
> > 2.I implement the state and timeout tracking of my own in the module.
> > 
> > For idea(1), There'll be in conflict with the NAT, because the NAT uses the hook.(ip_nat_core.c:ip_nat_init()&:ip_nat_cleanup())
> > For idea(2), I'll repeat the ip_conntrack's alogrithm, ALSO be not a good idea...
> > 
> > Then can I implement it in another way?
> > Such as: the conntrack support me one safty hook on conntrack destroy...(I think there is no such hooks)
> > 
> > 
> 
