From: Doug SC <dougsc@yahoo.com>
Subject: Inbound packet buffering
Date: Mon, 19 Jan 2004 06:34:54 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040119143454.34247.qmail@web11610.mail.yahoo.com>
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

Good Morning.

I have a kernel driver which has registered for
inbound packets.

nf_register_hook(...NF_IP_PRE_ROUTING...)

I am looking to take action on certain UDP ports on
packets which may exceed MTU.  I see the fragmented
packets at this hook and since I can't be certain of
the order of receipt I need to buffer packets until I
receive the fragment which contains the ports.

Once I can see the port I may want to send all the
packets I have buffered plus the one that allowed me
to make the decision.

I have looked around and thought that the
ip_local_deliver function in ip_input.c looked
promissing but it does not appear to be an exported
symbol.

Any info or pointers to existing code would be
appreciated.

Thanks

__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
