From: Guru Prasad <guru_netfilter@yahoo.com>
Subject: Waiting for user space response in Kernel Mode
Date: Mon, 5 Dec 2005 01:48:58 -0800 (PST)
Message-ID: <20051205094858.34850.qmail@web36409.mail.mud.yahoo.com>
References: <002f01c5f972$5da353a0$6602a8c0@acer21ce70712f>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <002f01c5f972$5da353a0$6602a8c0@acer21ce70712f>
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

I am a newbie to Kernel and Netfilter development.
  
When a new connection with specific parameters (for
example a certain destination IP address) is created,
I would like to indicate this event to a daemon
process in user space which takes some decision before
proceeding. I detect this event from 
ip_conntrack_netlink.c in the following function.
  
  int ctnetlink_conntrack_event(struct notifier_block 
*this,                                     
unsigned long events, void *ptr) -->    "if (events & 
(IPCT_NEW | 
IPCT_RELATED)) {"
  
When I detect a new connection,I tried to use
Wait_queues and call schedule() so that I could wait
on this process before receiving response from user
space, but using this mechanism leads to crashes. It
seems that one can only use this mechanism (wait
queues and schedule)  when a process is executing in
the context of a user space application.  
  
When executing in kernel mode, such as in case when
the ip stack is forwarding packets, how can one wait
for user space response before proceeding?
  
One solution I could think of is to queue the packets
until decision is  received from user space and then
to de-queue everything. 
  
I would like to know if anybody had encountered
similar problem and found a working solution.

Br
Guruprasad


		
__________________________________________ 
Yahoo! DSL – Something to write home about. 
Just $16.99/mo. or less. 
dsl.yahoo.com 
