From: Scott MacKay <scottmackay@yahoo.com>
Subject: Altering destination ethernet device
Date: Fri, 25 Jun 2004 06:01:42 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040625130142.54545.qmail@web13907.mail.yahoo.com>
References: <20040625111641.42357.qmail@web13908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040625111641.42357.qmail@web13908.mail.yahoo.com>
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
   Sorry if this was asked before by someone, but is
it possible to alter the destination interface for a
packet?  In example, if I have a packet coming in eth0
which could go out either eth1 or eth2, is there any
way to force it to eth2?   I would be looking for a
programming solution because the actual interface
selected will be based on some critea which is
programmed.  If it is possible, I would likely select
the new interface in mangle/POSTROUTING unless it
needed to be elsewhere.

-Scott


		
__________________________________
Do you Yahoo!?
Yahoo! Mail - Helps protect you from nasty viruses.
http://promotions.yahoo.com/new_mail
